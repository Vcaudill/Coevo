import pyslim
import tskit
import msprime
import numpy as np
import statistics
import os
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
# this file I use sort to potentally sole the problem of missmatching of children
# for filename in os.listdir('/home/vcaudill/kernlab/animate_center/files/'):
for filename in os.listdir('/home/vcaudill/kernlab/animate_center/files/'):
    if filename.endswith("_500_.trees"):

        myfile = filename.split(".trees")[0]
        print("myfile", myfile)
        # tree = pyslim.SlimTreeSequence.load('/Users/victoria/Desktop/biased_mig/trees/' + filename)
        ts = pyslim.load('/home/vcaudill/kernlab/animate_center/files/' + filename)
        sample_size = 2 * len(ts.individuals_alive_at(ts.slim_generation - 1))
        print("sample_size", sample_size)

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
        first_gen_nodes = np.sort(np.array(first_gen_nodes))  # CAN BE SORTED TOO
        print("first_gen_nodes", len(first_gen_nodes))
        target_time = 5
        print("sorted!")  # tested sort on talapas dot position did change
        # num_paths[i, j] = number of paths through the pedigree from node j to node i,
        #   for each j in first_gen
        # my_rand_node_sample_test = np.random.randint(0, len(first_gen_nodes), size=sample_size)
        # samlpe of the random nodes of individulas
        #my_rand_node_sample = np.random.choice(first_gen_nodes, sample_size)
        my_rand_node_sample = np.sort(np.random.choice(first_gen_nodes, sample_size, replace=False))

        num_paths = np.zeros((ts.num_nodes, len(first_gen_nodes)))
        # num_paths row in nodes, colmn in first gen nodes
        # if i was only taking a sample of this can I make the table from the sample
        for j, n in enumerate(first_gen_nodes):
            num_paths[n, j] = 1
        for t in range(ts.slim_generation - 2, -1, -1):
            # we will set these ones values in num_paths now
            newborn_nodes = np.where(ts.tables.nodes.time == t)[0]
            # equal to the sum of their parent(s)
            for n in newborn_nodes:
                parent_nodes = ts.tables.edges.parent[ts.tables.edges.child == n]
                # print(t, n, parent_nodes)
                for p in set(parent_nodes):
                    # for each newborn node its row in numpath to be equal to its parents
                    num_paths[n, :] += num_paths[p, :]
        num_rows, num_cols = num_paths.shape

        def num_paths_to(t):
            # return a vector of length first_gen_nodes
            # whose k-th entry is the total number of paths
            # from first_gen_node[k] to any node alive at time t
            target_nodes = []
            for ind in ts.individuals_alive_at(t):
                target_nodes.extend(ts.individual(ind).nodes)
            target_nodes = np.array(target_nodes)
            # print("target_nodes array", len(target_nodes), target_nodes)
            # print("target_nodes sum", len(np.sum(num_paths[target_nodes, :], axis=0)),
            #       np.sum(num_paths[target_nodes, :], axis=0))
            return np.sum(num_paths[target_nodes, :], axis=0)  # in order of first gen nodes
        print("rows colm", num_rows, num_cols)
        # these numbers should go like 2^k? well, if we had both parents always
        '''
        for t in range(ts.slim_generation - 1, 0, -1):
            alive = (ts.tables.nodes.time == t)
            print(t, "length ",
                  len(np.sum(num_paths[alive, :], axis=1)))
        '''
        kidos = []
        for year in reversed(range(0, ts.slim_generation, 1)):
            # kids might be going to the wrong first gen indiv
            kid_num_by_nodes = num_paths_to(year)[np.isin(first_gen_nodes, my_rand_node_sample)]
            # would be better to np.where() somewhere
            # combine each 2 nodes to turn back into an individual
            kid_num_by_ind = [int(sum(kid_num_by_nodes[current: current + 1]))
                              for current in range(0, len(kid_num_by_nodes), 2)]

            kidos.append(np.array(kid_num_by_ind).astype(np.float))
            print("Calculating offspring for generation", year)
        # print("kidos", kidos)
        np.savetxt('/home/vcaudill/kernlab/animate_center/csv/' + myfile + "_samplesize_" +
                   str(sample_size / 2) + "_timepoints_" + str(ts.slim_generation) + '.csv', kidos, delimiter=",")

        ind_to_plot = []
        for i_node in my_rand_node_sample:
                # truns nodes into individuals
            ind_to_plot_ind = nodes.individual[i_node]
            ind_to_plot.append(ind_to_plot_ind)

        def update(frame_number):
                # for year in range(9, 100, 10):
            year = frame_number % ts.slim_generation
            # means = statistics.mean(kidos[year])
            print(kidos[year].dtype)
            average = kidos[year][np.nonzero(kidos[year])].mean()
            Pointsize = np.ma.masked_equal((kidos[year] / average) * 10, 0)
            print(Pointsize.dtype)
            scat.set_sizes(Pointsize)  # I added np.array(Pointsize)
            # scat.set_offsets(locs[alive_sam, 0], locs[alive_sam, 1])
            Points['xy'][:, 0] = locs[ind_to_plot, 0]
            Points['xy'][:, 1] = locs[ind_to_plot, 1]
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
        # ax.scatter(locs[ind_to_plot, 0], locs[ind_to_plot, 1])  # blue points
        ax.set_ylabel(myfile)
        animation = FuncAnimation(fig, update, interval=600, frames=ts.slim_generation)
        scat = ax.scatter(0, 0,
                          s=1, edgecolors='none', color="red")

        animation.save('/home/vcaudill/kernlab/animate_center/sort_dub/an_' + myfile + "_samplesize_" +
                       str(sample_size) + "_timepoints_" + str(ts.slim_generation) + '.gif', writer='imagemagick', fps=10)
