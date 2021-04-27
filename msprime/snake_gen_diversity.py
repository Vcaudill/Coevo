import pyslim
import tskit
import msprime
from IPython.display import SVG
import numpy as np
import subprocess
#import util
# Neutral burn in with msprime, coalescent simulation
breaks = [0, 33333334, 66666667, 100000000]  # the length of the genome?
recomb_map = msprime.RateMap(
    position=breaks,
    rate=[1e-8, 1e-8, 1e-8])  # why do we set the recombination rate this way?
demog_model = msprime.Demography()
demog_model.add_population(initial_size=10000)
ots = msprime.sim_ancestry(
    samples=1000,  # number of individividuals sampled?
    demography=demog_model,
    random_seed=5,
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
    keep=True,
    random_seed=9)
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

# check we didn't mess anything up
assert tables.mutations.num_rows == ots.num_mutations
print(f"The selection coefficients range from {min(mut_map.values()):0.2e}")
print(f"to {max(mut_map.values()):0.2e}.")

ts_metadata = tables.metadata
ts_metadata["SLiM"]["model_type"] = "nonWF"
tables.metadata = ts_metadata
ots = tables.tree_sequence()
ots.dump("newt_snake/data/snakes_annotated.init.trees")

print(ots.sequence_length)
print(tables.metadata)

# This runs the slim simulation with the varables that you set
# subprocess.check_output(
#     ["slim", "-d", f"L={int(ots.sequence_length - 1)}",
#      "-s", "5", "msprime_test.slim"])