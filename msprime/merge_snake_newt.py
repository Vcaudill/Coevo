import tskit, pyslim
import numpy as np
import os

datadir = "newt_snake/data"

newts = pyslim.load(os.path.join(datadir, "newts_annotated.init.trees"))
snakes = pyslim.load(os.path.join(datadir, "snakes_annotated.init.trees"))

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

both = newts.union(
            snakes,
            node_mapping=np.repeat(tskit.NULL, snakes.num_nodes),
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

both.dump(os.path.join(datadir, "both_annotated.init.trees"))
