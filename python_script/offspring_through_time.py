import pandas as pd
import numpy as np
import pyslim
import os
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
# for filename in os.listdir('/Users/victoria/Desktop/Rotation_2020/bias_test_data/'):
for filename in os.listdir('/Users/victoria/Desktop/trackall'):
    if filename.endswith("1626980074634_late_10000_.trees"):

        myfile = filename.split(".trees")[0]
        print("myfile", myfile)
        # tree = pyslim.SlimTreeSequence.load('/Users/victoria/Desktop/biased_mig/trees/' + filename)
        #ts = pyslim.load('/Users/victoria/Desktop/trackall/' + filename)
        ts = pyslim.load(
            '/Users/victoria/Desktop/trackall/Bias_0.5_sigma_1_ID_1626980074634_late_10000_.trees')
        # ts = pyslim.load(
        #     '/Users/victoria/Desktop/trackall/Bias_0_sigma_0.35_ID_2708593720942_late_1000_.trees')
        # today = np.where(ts.individual_times == 0)[0]  # year you want to end "they are alive today"
        # ind_then = np.where(ts.individual_times == 10)[0]  # year you want to begin
    #    print("this is today", today, "today length", len(today))
        # alive = ts.individuals_alive_at(0)
        timepoints = ts.slim_generation - 1
        alive = np.where(ts.individual_times == (timepoints))[0]
        print('slim_generation', ts.slim_generation)
        #print("this is alive", alive, "alive length", len(alive))
        inds = ts.individuals_alive_at(99)
        # print("inds", inds, "length", len(in
        edges = ts.tables.edges
        child = edges.child
        parent = edges.parent
        dt = {"parent": parent, "child": child}
        sf = pd.DataFrame(dt)

        def find_the_kids(a, child_list):
            for child in child_list:
                if child not in full_kid_list:
                    #print("full_kid_list length", len(full_kid_list))
                    child_list = np.unique(sf.child[sf.parent == child].tolist())
                    full_kid_list.append(child)
                    # print("parent node", a, "new parent", child, "child(ren)", child_list)
                    find_the_kids(a, child_list)
                    # print("full kid list", full_kid_list)
            return full_kid_list
        samplesize = 150
        alive_sam = np.random.choice(alive, samplesize)
        print("alive_sam", alive_sam)
        node_list = []

        nodes = ts.tables.nodes
        dictOfkids = dict.fromkeys(alive_sam, [])
        count = 0
        for a in alive_sam:
            node_list = []
            # these are the nodes of my individuals alive at this time
            node_list.extend(ts.individual(a).nodes)
            # print("node_list", node_list)
            full_kid_list = []
            child_list = np.concatenate((np.unique(sf.child[sf.parent == node_list[0]].tolist()), np.unique(
                sf.child[sf.parent == node_list[1]].tolist())))
            # print("parent nodes", node_list[0], node_list[1], "child(ren)", child_list)
            full_kid_list_nodes = find_the_kids(a, child_list)
            full_kid_list_ind = np.array([])
            # print("full_kid_list_nodes", full_kid_list_nodes)

            for kid in full_kid_list_nodes:
                the_kids = int(nodes.individual[int(kid)])
                # print("kid node", kid, "the_kid ind", the_kids)
                full_kid_list_ind = np.append(full_kid_list_ind, the_kids)
            # print("parent", a, "kids", full_kid_list_ind)
            count += 1
            print(count / len(alive_sam) * 100, "% done, # of decendents ", len(full_kid_list_ind))
            # full_kid_list_ind.append(nodes.individual[kid])
            # print("full_kid_list_ind", full_kid_list_ind)
            # assert(np.all(full_kid_list_ind >= 0))
            dictOfkids[a] = np.unique(full_kid_list_ind).tolist()

        individual_nodes = []
        num_of_kids = []
        # print("alive_sam", alive_sam)
        # inds_to_look_for = ts.individuals_alive_at(30)

        fig = plt.figure(figsize=(9, 9))
        ax = fig.add_subplot(111)
        locs = ts.individual_locations
        xmax = np.ceil(max(locs[:, 0]))
        ymax = np.ceil(max(locs[:, 1]))
        ax.set_xlim(0, xmax)
        ax.set_ylim(0, ymax)

        # ax.scatter(locs[alive_sam, 0], locs[alive_sam, 1], s=1)

        def kid_by_year(year, dictOfkids):
            # inds_to_look_for = ts.individuals_alive_at(year)
            num_of_kids = []
            inds_to_look_for = np.where(ts.individual_times == year)[0]
            for key in dictOfkids:
                individual_nodes.append(key)
                # print("key", key, "values", dictOfkids[key])
                num_of_kids.append(len(set(dictOfkids[key]) & set(inds_to_look_for)))
            return num_of_kids

        def zero_to_nan(alive_sam, kid_num):
            """Replace every 0 with 'nan' and return a copy."""
            ret_list = []
            for x in range(0, len(kid_num)):
                if kid_num[x] != 0:
                    ret_list.append(int(alive_sam[x]))
            return ret_list

        kidos = []
        existing_sam = []
        for year in reversed(range(0, timepoints, 1)):
            kid_num = kid_by_year(year, dictOfkids)
            kidos.append(kid_num)
            ato = zero_to_nan(alive_sam, kid_num)
            # print(" ato ", ato)
            existing_sam.append(ato)
            # print(year)
            # print("num_parents", len(alive_sam), "num_of_kids", kidos[99 - year], "at year", 99 - year)
            # print(max(kidos[99 - year]), sum(kidos[99 - year]))
        # print(existing_sam)

        def update(frame_number):
            # for year in range(9, 100, 10):
            year = frame_number % timepoints
            Pointsize = np.ma.masked_equal(kidos[year], 0)
            scat.set_sizes(Pointsize)
            # scat.set_offsets(locs[alive_sam, 0], locs[alive_sam, 1])
            Points['xy'][:, 0] = locs[alive_sam, 0]
            Points['xy'][:, 1] = locs[alive_sam, 1]
            scat.set_sizes(Pointsize)
            scat.set_offsets(Points['xy'])
            scat.set_array(np.array(kidos[year]))
            ax.set_title("Generation %d" % year)
            ax.set_ylabel(filename)

        t = list(range(0, timepoints, 1))
        Pointsize = [10] * 3
        Points = np.zeros(samplesize, dtype=[('xy', float, 2)])
        ax.scatter(locs[alive_sam, 0], locs[alive_sam, 1])
        animation = FuncAnimation(fig, update, interval=600, frames=timepoints)
        scat = ax.scatter(0, 0,
                          s=1, edgecolors='none', color="red")

        animation.save('/Users/victoria/Desktop/' + filename + "_samplesize_" +
                       str(samplesize) + "_timepoints_" + str(timepoints) + '.gif', writer='imagemagick', fps=10)
#        plt.show()
