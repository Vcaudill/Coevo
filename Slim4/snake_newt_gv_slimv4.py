import pyslim
import tskit
import msprime
import numpy as np
import os
import sys
from sys import argv
# import util

sequence_length = 10000000
mytag="no_tag"

datadir = "."
snake_mu_rate = 6.25e-12
newt_mu_rate = 2.5e-09 # does this need to be 50 times more than the snake?
snake_mu_effect_sd = 0.2
newt_mu_effect_sd = 0.2
mytag="beta_exp"
'''

snake_mu_rate = float(sys.argv[1])
newt_mu_rate = float(sys.argv[2])  # does this need to be 50 times more than the snake?
snake_mu_effect_sd = float(sys.argv[3])
newt_mu_effect_sd = float(sys.argv[4])
datadir = sys.argv[5]
mytag = sys.argv[6]
'''
newt_name_of_file = "newt_" + "nu_" + str(newt_mu_rate) + "_nue_" + str(newt_mu_effect_sd) + "_" + mytag + ".init.trees"
snake_name_of_file = "snake_" + "su_" + str(snake_mu_rate) + "_sue_" + str(snake_mu_effect_sd) + "_" + mytag + ".init.trees"
print(newt_name_of_file, snake_name_of_file)


def add_mutations(ts, mut_type, mu_rate, effect_sd, next_id=0):
    # s_fn draws the selection coefficient
    # need to assign metadata to be able to put the mutations in
    mut_model = msprime.SLiMMutationModel(type=mut_type, next_id=next_id)
    mts = msprime.sim_mutations(
        ts,
        mu_rate,
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
    return tables.tree_sequence()


# Snakes:
snake_demog = msprime.Demography()
snake_demog.add_population(name="p0", initial_size=10000)
snakes = msprime.sim_ancestry(
    samples={"p0": 300},  # number of individividuals sampled
    demography=snake_demog,
    recombination_rate=1e-8,
    sequence_length=sequence_length)

snakes = pyslim.annotate(
    snakes,
    model_type='nonWF',
    tick=1,
)

# add mutations
snakes = add_mutations(
    snakes,
    mut_type=2,
    mu_rate=snake_mu_rate,
    effect_sd=snake_mu_effect_sd)

# snakes should be in population 0 and have mutations of type 2
for n in snakes.nodes():
    assert n.population == 0

for m in snakes.mutations():
    for md in m.metadata['mutation_list']:
        assert md['mutation_type'] == 2

# Newts:
newt_demog = msprime.Demography()
newt_demog.add_population(name="p1", initial_size=10000)
newts = msprime.sim_ancestry(
    samples={"p1": 300},  # number of individividuals sampled
    demography=newt_demog,
    recombination_rate=1e-8,
    sequence_length=sequence_length)

newts = pyslim.annotate(
    newts,
    model_type='nonWF',
    tick=1,
)

newts = add_mutations(
    newts,
    mut_type=1,
    mu_rate=newt_mu_rate,
    effect_sd=newt_mu_effect_sd,
    # this is so the newt mutation IDs will be after the snakes:
    next_id=snakes.num_mutations)

for m in newts.mutations():
    for md in m.metadata['mutation_list']:
        assert md['mutation_type'] == 1

newts.dump(os.path.join(datadir, newt_name_of_file))
print("newt file", str(os.path.join(datadir, newt_name_of_file)))
snakes.dump(os.path.join(datadir, snake_name_of_file))
print("snake file", str(os.path.join(datadir, snake_name_of_file)))
