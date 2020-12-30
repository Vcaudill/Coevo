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
file_dir = '/Users/victoria/Desktop/bias_test_data/test_10_4/'
for filename in os.listdir(file_dir):
    if filename.endswith("2478_late_10_.trees"):

        myfile = filename.split(".trees")[0]
        print("myfile", myfile)
        # tree = pyslim.SlimTreeSequence.load('/Users/victoria/Desktop/biased_mig/trees/' + filename)
        # ts = pyslim.load('/home/vcaudill/kernlab/animate_center/files/' + filename)
        ts = pyslim.load(file_dir + filename)
# this file only has 10 generations for testing

        sample_size = len(ts.individuals_alive_at(ts.slim_generation - 1))
        print("sample_size", sample_size)

        first_gen = ts.individuals_alive_at(ts.slim_generation - 1)

        print("Total Number of individuals", ts.num_individuals)
        print("first_gen", first_gen)  # these are the individuals

        print(ts.individual_parents())
        parent_table = ts.individual_parents()
        print(parent_table.all(0))
        find = np.where(parent_table == 8)
        parent_dict = {}  # making a dictionary might not need
        for a, b in parent_table:
            if b not in parent_dict:
                parent_dict[b] = []
            parent_dict[b].append(a)

        def get_key(val):
            for key, value in parent_dict.items():
                if val == value:
                    return key

            return "key doesn't exist"

        print(parent_dict)
        print(get_key(8))
        print(parent_table[parent_table[:, 1] == 8, 0])
        print(np.where(find == 1))
        result = parent_table[find]

        print("result: {}".format(result))
        print(parent_table[25][0])

        for time in reversed(range(0, ts.slim_generation, 1)):
            print("generation ", time, " ", ts.individuals_alive_at(time))

        num_paths = np.zeros((ts.num_nodes, len(first_gen)))
        # num_paths row in ind, colmn in first gen individual
        # if i was only taking a sample of this can I make the table from the sample
        # what is this code doing
        for j, n in enumerate(first_gen):
            num_paths[n, j] = 1
        for t in range(ts.slim_generation - 2, -1, -1):
            # we will set these ones values in num_paths now

            newborn_ind = np.setdiff1d(ts.individuals_alive_at(t), ts.individuals_alive_at(t + 1))
            # equal to the sum of their parent(s)
            for n in newborn_ind:

                parent_ind = parent_table[parent_table[:, 1] == n, 0]
                # print(parent_table[10][[1]])

                for p in set(parent_ind):
                    # for each newborn ind its row in numpath to be equal to its parents
                    num_paths[n, :] += num_paths[p, :]
        num_rows, num_cols = num_paths.shape
        np.savetxt(file_dir + 'table_' + myfile + "_samplesize_" +
                   str(sample_size / 2) + "_timepoints_" + str(ts.slim_generation) + '.txt', num_paths, delimiter="    ", fmt='%d')

        # try to set up the table by individual

        def num_paths_to(t):
            # return a vector of length first_gen_ind
            # whose k-th entry is the total number of paths
            # from first_gen_ind[k] to any ind alive at time t
            target_ind = []
            target_ind = np.array(ts.individuals_alive_at(t))

            return np.sum(num_paths[target_ind, :], axis=0)  # in order of first gen
        print("rows colm", num_rows, num_cols)

        kidos = []
        for year in reversed(range(0, ts.slim_generation, 1)):
            # kids might be going to the wrong first gen indiv
            kid_num_by_ind = num_paths_to(year)[np.isin(
                first_gen, first_gen)]  # might need to change later
            # would be better to np.where() somewhere
            kidos.append(np.array(kid_num_by_ind).astype(np.float))
            print("Calculating offspring for generation", year)
        # print("kidos", kidos)

        # saving the table of decendents should be ancestor by generations (c, r)
        np.savetxt(file_dir + 'csv/dec_' + myfile + "_samplesize_" +
                   str(sample_size / 2) + "_timepoints_" + str(ts.slim_generation) + '.txt', kidos, delimiter="    ", fmt='%d')

        # saving location of the first generation
        np.savetxt(file_dir + 'csv/loc_' + myfile + "_samplesize_" +
                   str(sample_size / 2) + "_timepoints_" + str(ts.slim_generation) + '.txt', ts.individual_locations[first_gen], delimiter="    ", fmt='%d')

        def update(frame_number):
                    # for year in range(9, 100, 10):
            year = frame_number % ts.slim_generation
            print("year", year)
            # means = statistics.mean(kidos[year])
            # print("kido of year type", kidos[year].dtype)
            average = kidos[year][np.nonzero(kidos[year])].mean()
            Pointsize = np.ma.masked_equal((kidos[year] / average) * 10, 0)
            # print("Pointsize dtpye", Pointsize.dtype)
            scat.set_sizes(np.array(Pointsize))
            # scat.set_offsets(locs[alive_sam, 0], locs[alive_sam, 1])
            Points['xy'][:, 0] = locs[first_gen, 0]
            Points['xy'][:, 1] = locs[first_gen, 1]
            # print(Pointsize)
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

        Points = np.zeros(len(ts.individuals_alive_at(ts.slim_generation - 1)),
                          dtype=[('xy', float, 2)])
        # ax.scatter(locs[ind_to_plot, 0], locs[ind_to_plot, 1])  # blue points
        ax.set_ylabel(myfile)
        animation = FuncAnimation(fig, update, interval=600, frames=ts.slim_generation)
        scat = ax.scatter(0, 0,
                          s=1, edgecolors='none', color="red")

        animation.save(file_dir + myfile + "_samplesize_" +
                       str(sample_size) + "_timepoints_" + str(ts.slim_generation) + '.gif', writer='imagemagick', fps=10)
