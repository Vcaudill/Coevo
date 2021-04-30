import pyslim
import tskit
import msprime
from IPython.display import SVG
import numpy as np
import subprocess
import os
# import util
datadir = "newt_snake/data"
# Neutral burn in with msprime, coalescent simulation
breaks = [0, 33333334, 66666667, 100000000]  # the length of the genome?
recomb_map = msprime.RateMap(
    position=breaks,
    rate=[1e-8, 1e-8, 1e-8])  # why do we set the recombination rate this way?
demog_model = msprime.Demography()
print("Working on Snake Sim")
demog_model.add_population(name="p0", initial_size=100)
ots = msprime.sim_ancestry(
    samples=10,  # number of individividuals sampled?
    demography=demog_model,
    # random_seed=5,
    recombination_rate=recomb_map)

ots = pyslim.annotate_defaults(ots, model_type="nonWF", slim_generation=1)
# this is adding anotation or metadata to all of the individuals
mut_map = msprime.RateMap(
    position=breaks,
    rate=[1e-10, 1e-10, 1e-10])  # what rate(s) would I put in here
mut_model = msprime.SLiMMutationModel(type=2)  # mutation "m2"
ots = msprime.sim_mutations(
    ots,
    rate=mut_map,
    model=mut_model,
    # random_seed=9
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
            mut_map[sid] = np.random.exponential(scale=0.5)  # the snakes higher mean
        md["selection_coeff"] = mut_map[sid]
    _ = tables.mutations.add_row(
        site=m.site,
        node=m.node,
        time=m.time,
        derived_state=m.derived_state,
        parent=m.parent,
        metadata={"mutation_list": md_list})

# Adding location information to individuals metadata
tables.populations.clear()
for p in ots.populations():
    pm = p.metadata
    pm['bounds_x1'] = 1.0
    pm['bounds_y1'] = 1.0
    tables.populations.add_row(metadata=pm)

# check we didn't mess anything up
assert tables.mutations.num_rows == ots.num_mutations
print(f"The selection coefficients range from {min(mut_map.values()):0.2e}")
print(f"to {max(mut_map.values()):0.2e}.")

ts_metadata = tables.metadata
ts_metadata["SLiM"]["model_type"] = "nonWF"
tables.metadata = ts_metadata
ots = tables.tree_sequence()

# newt
print("Working on Newt Sim")
breaks = [0, 33333334, 66666667, 100000000]  # the length of the genome?
recomb_map_1 = msprime.RateMap(
    position=breaks,
    rate=[1e-8, 1e-8, 1e-8])  # why do we set the recombination rate this way?
demog_model_1 = msprime.Demography()
demog_model_1.add_population(name="p0", initial_size=3)
demog_model_1.add_population(name="p1", initial_size=100)
ots_1 = msprime.sim_ancestry(
    samples={"p1": 10},  # number of individividuals sampled?
    # samples={"p1": 1, "p2": 1},
    demography=demog_model_1,
    # random_seed=5,
    recombination_rate=recomb_map_1)

ots_1 = pyslim.annotate_defaults(ots_1, model_type="nonWF", slim_generation=1)
# this is adding anotation or metadata to all of the individuals

mut_map_1 = msprime.RateMap(
    position=breaks,
    rate=[1e-10, 1e-10, 1e-10])  # what rate(s) would I put in here
# needs to be the snakes number  # mutation "m1"
snake_mutations = ots.num_mutations  # this is so the newt mutation tag will be after the snakes
mut_model_1 = msprime.SLiMMutationModel(type=1, next_id=snake_mutations)
ots_1 = msprime.sim_mutations(
    ots_1,
    rate=mut_map_1,
    model=mut_model_1,
    # random_seed=19
)
print(f"The tree sequence now has {ots_1.num_mutations} mutations, at "
      f"{ots_1.num_sites} distinct sites.")

tables_1 = ots_1.tables
tables_1.mutations.clear()
mut_map_1 = {}
for m in ots_1.mutations():
    md_list_1 = m.metadata["mutation_list"]
    slim_ids_1 = m.derived_state.split(",")
    assert len(slim_ids_1) == len(md_list_1)
    for sid, md in zip(slim_ids_1, md_list_1):
        if sid not in mut_map_1:
            mut_map_1[sid] = np.random.exponential(scale=0.01)  # the newts lower mean
        md["selection_coeff"] = mut_map_1[sid]
    _ = tables_1.mutations.add_row(
        site=m.site,
        node=m.node,
        time=m.time,
        derived_state=m.derived_state,
        parent=m.parent,
        metadata={"mutation_list": md_list_1})

# Adding location information to individuals metadata
tables_1.populations.clear()
for p in ots_1.populations():
    pm = p.metadata
    pm['bounds_x1'] = 1.0
    pm['bounds_y1'] = 1.0
    tables_1.populations.add_row(metadata=pm)

# check we didn't mess anything up
assert tables_1.mutations.num_rows == ots_1.num_mutations
print(f"The selection coefficients range from {min(mut_map_1.values()):0.2e}")
print(f"to {max(mut_map_1.values()):0.2e}.")

ts_metadata_1 = tables_1.metadata
ts_metadata_1["SLiM"]["model_type"] = "nonWF"
tables_1.metadata = ts_metadata_1
ots_1 = tables_1.tree_sequence()

# Merge snake and newts

# mts = ots.union(ots_1, node_mapping=np.repeat(tskit.NULL, ots_1.num_nodes))
# assert ots.num_mutations > 0
# ots.dump(os.path.join(datadir, "both_newt_snake_annotated.init.trees"))

both = ots_1.union(
    ots,
    node_mapping=np.repeat(tskit.NULL, ots.num_nodes),
    add_populations=False
)
both = pyslim.SlimTreeSequence(both)

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
            assert both.node(n).population == right_pop


# every tree should have exactly two roots
for t in both.trees():
    assert t.num_roots == 2, "Uh-oh, a tree did not have two roots!"

alive = both.individuals_alive_at(0)
for p in both.populations():
    print(f"Population {p.id} has SLiM ID {p.metadata['slim_id']}")
    num_indivs = sum(both.individual_populations[alive] == p.id)
    print(f"  and there are {num_indivs} individuals alive in it.")

both.dump(os.path.join(datadir, "both_newt_snake_annotated.init.trees"))
