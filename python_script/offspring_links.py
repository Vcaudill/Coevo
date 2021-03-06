import pyslim
import tskit
import msprime
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

# this file only has 10 generations for testing
'''
ts = pyslim.load(
    "/Users/victoria/Desktop/bias_test_data/Bias_0.1_sigma_1_ID_1820680293725_late_50000_.trees")
'''
ts = pyslim.load(
    '/Users/victoria/Desktop/bias_test_data/Bias_0.15_sigma_0.8_ID_1602158267717_late_100_.trees')

#sample_size = len(ts.individuals_alive_at(ts.slim_generation - 1))
sample_size = 200
filename = "100_gen_test"
# NODES:
# find children of first_gen at target time
# where "children" means number paths to anyone alive at target time
# NODES:
# find children of first_gen at target time
# where "children" means number paths to anyone alive at target time
first_gen = ts.individuals_alive_at(ts.slim_generation - 1)
print("first_gen", first_gen)  # these are the individuals
first_gen_nodes = []

nodes = ts.tables.nodes
times = nodes.time
my_nodes = nodes.individual

for ind in first_gen:
    first_gen_nodes.extend(ts.individual(ind).nodes)
first_gen_nodes = np.array(first_gen_nodes)
target_time = 5
# num_paths[i, j] = number of paths through the pedigree from node j to node i,
#   for each j in first_gen
# my_rando_sample_test = np.random.randint(0, len(first_gen_nodes), size=sample_size)
# samlpe of the random nodes of individulas
my_rando_sample = np.random.choice(first_gen_nodes, sample_size)
num_paths = np.zeros((ts.num_nodes, len(first_gen_nodes)))
for n in first_gen_nodes:
    num_paths[n, n] = 1
for t in range(ts.slim_generation - 2, -1, -1):
    # we will set these ones values in num_paths now
    newborn_nodes = np.where(ts.tables.nodes.time == t)[0]
    # equal to the sum of their parent(s)
    for n in newborn_nodes:
        parent_nodes = ts.tables.edges.parent[ts.tables.edges.child == n]
        #print(t, n, parent_nodes)
        for p in set(parent_nodes):
            num_paths[n, :] += num_paths[p, :]


def num_paths_to(t):
    # return a vector of length first_gen_nodes
    # whose k-th entry is the total number of paths
    # from first_gen_node[k] to any node alive at time t
    target_nodes = []
    for ind in ts.individuals_alive_at(t):
        target_nodes.extend(ts.individual(ind).nodes)
    target_nodes = np.array(target_nodes)
    return np.sum(num_paths[target_nodes, :], axis=0)


# these numbers should go like 2^k? well, if we had both parents always
'''
for t in range(ts.slim_generation - 1, 0, -1):
    alive = (ts.tables.nodes.time == t)
    print(t, "length ",
          len(np.sum(num_paths[alive, :], axis=1)))
'''
kidos = []

for year in reversed(range(0, ts.slim_generation, 1)):
    kid_num = num_paths_to(year)[my_rando_sample]  # need the indieces of the nodes
    #np.isin(my_rando_sample, first_gen_nodes)
    #kid_num_2 = num_paths_to(year)[my_rando_sample_test]
    #print("kid compair", kid_num, kid_num_2)
    kidos.append(kid_num)
    print("Calculating offspring for generation", year)
# print("kidos", kidos)

'''
for t in range(ts.slim_generation - 1, 0, -1):
    print(num_paths_to(t)[my_rando_sample], len(num_paths_to(t)))

'''
ran_sample = []
for indv in my_rando_sample:
    # truns nodes into individuals
    ran_sample_ind = int(nodes.individual[int(indv)])
    ran_sample.append(int(ran_sample_ind))
    #ran_sample = ran_sample.append(ran_sample_ind)


def update(frame_number):
    # for year in range(9, 100, 10):
    year = frame_number % ts.slim_generation
    Pointsize = np.ma.masked_equal(kidos[year], 0)
    scat.set_sizes(Pointsize)
    # scat.set_offsets(locs[alive_sam, 0], locs[alive_sam, 1])
    Points['xy'][:, 0] = locs[ran_sample, 0]
    Points['xy'][:, 1] = locs[ran_sample, 1]
    scat.set_sizes(Pointsize)
    scat.set_offsets(Points['xy'])
    scat.set_array(np.array(kidos[year]))
    ax.set_title("Generation %d" % year)


fig = plt.figure(figsize=(9, 9))
ax = fig.add_subplot(111)
locs = ts.individual_locations
xmax = np.ceil(max(locs[:, 0]))
ymax = np.ceil(max(locs[:, 1]))
ax.set_xlim(0, xmax)
ax.set_ylim(0, ymax)

t = list(range(0, ts.slim_generation, 1))
Pointsize = [10] * 3
Points = np.zeros(sample_size, dtype=[('xy', float, 2)])
# ax.scatter(locs[ran_sample, 0], locs[ran_sample, 1])  # blue points
ax.set_ylabel(filename)
animation = FuncAnimation(fig, update, interval=600, frames=ts.slim_generation)
scat = ax.scatter(0, 0,
                  s=1, edgecolors='none', color="red")

animation.save('/Users/victoria/Desktop/test_' + filename + "_samplesize_" +
               str(sample_size) + "_timepoints_" + str(ts.slim_generation) + '.gif', writer='imagemagick', fps=10)
