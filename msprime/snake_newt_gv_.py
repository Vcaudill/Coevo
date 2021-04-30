import pyslim
import tskit
import msprime
from IPython.display import SVG
import numpy as np
import subprocess
import os
# import util

datadir = "newt_snake/data"
sequence_length = 100000000

# TODO: add mutation rate as an argument
# so we can use different mutation rates for snakes and newts


def s_fn(value):
    return np.random.normal(loc=0.0, scale=value)


def add_mutations(ots, mut_type, s_fn_v, next_id=0):
    # s_fn draws the selection coefficient
    # need to assign metadata to be able to put the mutations in
    mut_model = msprime.SLiMMutationModel(type=mut_type, next_id=next_id)
    ots = msprime.sim_mutations(
        ots,
        rate=1e-10,
        model=mut_model,
    )
    print(f"The tree sequence now has {ots.num_mutations} mutations, at "
          f"{ots.num_sites} distinct sites.")
    tables = ots.tables
    tables.mutations.clear()
    mut_map = {}
    for m in ots.mutations():
        md_list = m.metadata["mutation_list"]
        slim_ids = m.derived_state.split(",")
        assert len(slim_ids) == len(md_list)
        for sid, md in zip(slim_ids, md_list):
            if sid not in mut_map:
                mut_map[sid] = s_fn(s_fn_v)
            md["selection_coeff"] = mut_map[sid]
        _ = tables.mutations.add_row(
            site=m.site,
            node=m.node,
            time=m.time,
            derived_state=m.derived_state,
            parent=m.parent,
            metadata={"mutation_list": md_list})
    assert tables.mutations.num_rows == ots.num_mutations
    print(f"The selection coefficients range from {min(mut_map.values()):0.2e}")
    print(f"to {max(mut_map.values()):0.2e}.")
    return tables.tree_sequence()


# Snakes:
demog_model = msprime.Demography()
demog_model.add_population(name="p0", initial_size=100)
snakes = msprime.sim_ancestry(
    samples={"p0": 10},  # number of individividuals sampled
    demography=demog_model,
    recombination_rate=1e-8,
    sequence_length=sequence_length)

snakes = pyslim.annotate_defaults(snakes, model_type="nonWF", slim_generation=1)
# add mutations
snakes = add_mutations(
    snakes,
    mut_type=2,
    s_fn_v=0.5)  # lambda :np.random.normal(loc=0.0, scale=0.5)

# Newts:
demog_model_1 = msprime.Demography()
demog_model_1.add_population(name="p0", initial_size=3)
demog_model_1.add_population(name="p1", initial_size=100)
newts = msprime.sim_ancestry(
    samples={"p1": 10},  # number of individividuals sampled
    demography=demog_model_1,
    recombination_rate=1e-8,
    sequence_length=sequence_length)

snake_mutations = snakes.num_mutations  # this is so the newt mutation IDs will be after the snakes
newts = pyslim.annotate_defaults(newts, model_type="nonWF", slim_generation=1)
newts = add_mutations(
    snakes,
    mut_type=1,
    s_fn_v=0.01,  # lambda x:
    next_id=snake_mutations)

# snakes should be in population 0 and have mutations of type 2
for n in snakes.nodes():
    assert n.population == 0

for m in snakes.mutations():
    for md in m.metadata['mutation_list']:
        assert md['mutation_type'] == 2


# newts should be in population 1 and have mutations of type 1
for n in newts.nodes():
    assert n.population == 1

for m in newts.mutations():
    for md in m.metadata['mutation_list']:
        assert md['mutation_type'] == 1


# Merge
both = pyslim.SlimTreeSequence(
    newts.union(
        snakes,
        node_mapping=np.repeat(tskit.NULL, snakes.num_nodes),
        add_populations=False
    )
)

tables = both.tables
print(both.metadata)
# Adding location information to individuals metadata
tables.populations.clear()
for p in both.populations():
    pm = p.metadata
    pm['bounds_x1'] = 1.0
    pm['bounds_y1'] = 1.0
    tables.populations.add_row(metadata=pm)

both = tables.tree_sequence()

# population 0 = snakes = mutations of type 2
# NOTE: this takes a bit, and we could only check the first 100 if we wanted
for t in both.trees():
    for m in t.mutations():
        mut_type = m.metadata['mutation_list'][0]['mutation_type']
        if mut_type == 1:
            right_pop = 1
        else:
            assert mut_type == 2
            right_pop = 0
        for n in t.samples(u=m.node):
            #print(n, right_pop, both.node(n).population)
            assert both.node(n).population == right_pop

both = pyslim.SlimTreeSequence(both)
# every tree should have exactly two roots
for t in both.trees():
    assert t.num_roots == 2, "Uh-oh, a tree did not have two roots!"

alive = both.individuals_alive_at(0)
for p in both.populations():
    print(f"Population {p.id} has SLiM ID {p.metadata['slim_id']}")
    num_indivs = sum(both.individual_populations[alive] == p.id)
    print(f"  and there are {num_indivs} individuals alive in it.")

both.dump(os.path.join(datadir, "both_newt_snake_annotated.init.trees"))
