import pyslim
import tskit
import msprime
import numpy as np
import os
# import util

datadir = "newt_snake/data"
sequence_length = 100000000

# TODO: add mutation rate as an argument
# so we can use different mutation rates for snakes and newts

def add_mutations(ts, mut_type, effect_sd, next_id=0):
    # s_fn draws the selection coefficient
    # need to assign metadata to be able to put the mutations in
    mut_model = msprime.SLiMMutationModel(type=mut_type, next_id=next_id)
    mts = msprime.sim_mutations(
        ts,
        rate=1e-10,
        model=mut_model,
    )
    print(f"The tree sequence now has {mts.num_mutations} mutations, at "
          f"{mts.num_sites} distinct sites.")
    tables = mts.tables
    tables.mutations.clear()
    mut_map = {}
    for m in mts.mutations():
        md_list = m.metadata["mutation_list"]
        slim_ids = m.derived_state.split(",")
        assert len(slim_ids) == len(md_list)
        for sid, md in zip(slim_ids, md_list):
            if sid not in mut_map:
                mut_map[sid] = np.random.normal(loc=0.0, scale=effect_sd)
            md["selection_coeff"] = mut_map[sid]
        tables.mutations.add_row(
            site=m.site,
            node=m.node,
            time=m.time,
            derived_state=m.derived_state,
            parent=m.parent,
            metadata={"mutation_list": md_list})
    assert tables.mutations.num_rows == mts.num_mutations
    print(f"The selection coefficients range from {min(mut_map.values()):0.2e}")
    print(f"to {max(mut_map.values()):0.2e}.")
    return mts


# Snakes:
snake_demog = msprime.Demography()
snake_demog.add_population(name="p0", initial_size=100)
snakes = msprime.sim_ancestry(
    samples={"p0": 10},  # number of individividuals sampled
    demography=snake_demog,
    recombination_rate=1e-8,
    sequence_length=sequence_length)

snakes = pyslim.annotate_defaults(
            snakes,
            model_type='nonWF',
            slim_generation=1,
        )

# add mutations
snakes = add_mutations(
    snakes,
    mut_type=2,
    effect_sd=0.5)

# snakes should be in population 0 and have mutations of type 2
for n in snakes.nodes():
    assert n.population == 0

for m in snakes.mutations():
    for md in m.metadata['mutation_list']:
        assert md['mutation_type'] == 2

# Newts:
newt_demog = msprime.Demography()
newt_demog.add_population(name="p0", initial_size=3)
newt_demog.add_population(name="p1", initial_size=100)
newts = msprime.sim_ancestry(
    samples={"p1": 10},  # number of individividuals sampled
    demography=newt_demog,
    recombination_rate=1e-8,
    sequence_length=sequence_length)

newts = pyslim.annotate_defaults(
            newts,
            model_type='nonWF',
            slim_generation=1,
        )

newts = add_mutations(
    newts,
    mut_type=1,
    effect_sd=0.01,
    # this is so the newt mutation IDs will be after the snakes:
    next_id=snakes.num_mutations)

# newts should be in population 1 and have mutations of type 1
for n in newts.nodes():
    assert n.population == 1

for m in newts.mutations():
    for md in m.metadata['mutation_list']:
        assert md['mutation_type'] == 1


# Merge
both = newts.union(
        snakes,
        node_mapping=np.repeat(tskit.NULL, snakes.num_nodes),
        add_populations=False
    )
both = pyslim.SlimTreeSequence(both)

tables = both.tables

# Fixing up population metadata with spatial bounds
# (which will be re-edited in SLiM anyhow)
tables.populations.clear()
for p in both.populations():
    pm = p.metadata
    pm['bounds_x1'] = 1.0
    pm['bounds_y1'] = 1.0
    tables.populations.add_row(metadata=pm)

# Fixing up individual and genome SLiM IDs
tables.individuals.clear()
ind_map = {}
next_id = 0
for ind in both.individuals():
    md = ind.metadata
    md['pedigree_id'] = next_id
    j = tables.individuals.add_row(
            flags=ind.flags,
            location=ind.location,
            parents=ind.parents,
            metadata=md
    )
    ind_map[j] = md['pedigree_id']
    next_id += 1

tables.nodes.clear()
# hack because of https://github.com/tskit-dev/tskit/issues/1256
# (which is fixed in github main)
schema = tables.nodes.metadata_schema
tables.nodes.metadata_schema = tskit.MetadataSchema(None)
for n in both.nodes():
    md = n.metadata
    if md is not None:
        assert n.individual != tskit.NULL
        ind = both.individual(n.individual)
        offset = md['slim_id'] - 2 * ind.metadata['pedigree_id']
        md['slim_id'] = 2 * ind_map[ind.id] + offset
    tables.nodes.add_row(
            time=n.time,
            population=n.population,
            individual=n.individual,
            flags=n.flags,
            metadata=schema.validate_and_encode_row(md)
    )
tables.nodes.metadata_schema = schema

both = tables.tree_sequence()

# check mutations are consistent
mut_info = {}
for m in both.mutations():
    for a, md in zip(m.derived_state.split(","), m.metadata['mutation_list']):
        if a in mut_info:
            assert mut_info[a] == md, f"Mismatch for ID {a}: {mut_info[a]} and {md} differ."
        else:
            mut_info[a] = md

# check individual IDs are unique
# and consistent with genome IDs
ind_ids = []
for ind in both.individuals():
    pid = ind.metadata['pedigree_id']
    assert pid not in ind_ids, f"Duplicate individual ID pid"
    ind_ids.append(pid)
    node_ids = [both.node(n).metadata['slim_id'] for n in ind.nodes]
    assert set(node_ids) == set([2 * pid + k for k in range(2)])

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
