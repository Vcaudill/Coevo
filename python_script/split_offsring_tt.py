import pandas as pd
import numpy as np
import pyslim
import os
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

# for filename in os.listdir('/Users/victoria/Desktop/Rotation_2020/bias_test_data/'):
# cycle through a folder to make multiple animations
for filename in os.listdir('/Users/victoria/Desktop/trackall'):
    if filename.endswith("1626980074634_late_10000_.trees"):
        # doing this for a test file
        myfile = filename.split(".trees")[0]
        print("myfile", myfile)
        # tree = pyslim.SlimTreeSequence.load('/Users/victoria/Desktop/biased_mig/trees/' + filename)
        # ts = pyslim.load('/Users/victoria/Desktop/trackall/' + filename)
        # 100 gen file
        ts = pyslim.load(
            '/Users/victoria/Desktop/bias_test_data/Bias_0.15_sigma_0.8_ID_1602158267717_late_100_.trees')
# longer 500 gen file
        # ts = pyslim.load(
        #    '/Users/victoria/Desktop/trackall/Bias_0.5_sigma_1_ID_1626980074634_late_10000_.trees')

        # ts = pyslim.load(
        #     '/Users/victoria/Desktop/trackall/Bias_0_sigma_0.35_ID_2708593720942_late_1000_.trees')
        # timepoints = the number of generations in a simulation
        timepoints = ts.slim_generation - 1
        alive = np.where(ts.individual_times == (timepoints))[0]  # beging gen
        print('slim_generation', ts.slim_generation)
        Y = np.arange((ts.slim_generation / 10), ts.slim_generation, 10)
        Y = np.append(Y, timepoints)  # to get to the very last gen
        # Y = [10, 20, 30, 40, 50]  # times i picked but enventually it will be devided up
        print("list intervals", Y)
        inds = ts.individuals_alive_at(99)
        # edge table [left, right, parent, child]
        edges = ts.tables.edges
        child = edges.child
        parent = edges.parent
        # node table [individuls, time (time ago?)]
        nodes = ts.tables.nodes
        times = nodes.time
        my_nodes = nodes.individual

        # made a dataframe with parent and child but might chage it to the pre-existing edge table
        dt = {"parent": parent, "child": child}
        sf = pd.DataFrame(dt)
        # print(times[my_nodes == 123671])

        def find_the_kids(a, child_list, temp_node_list, full_kid_list, for_next_sec, still_check, return_list):
            still_check = child_list
            # still_check is a list of all the kids that have not been checked
            for child in np.unique(still_check):
                if child in temp_node_list:
                    # temp_node_list is where i want to stop the cycle
                    for_next_sec.append(child)
                    full_kid_list.append(child)
                    if child in still_check:
                        still_check = np.delete(still_check, np.where(still_check == child))
                    continue
                if child in still_check and child not in full_kid_list:
                    # print("full_kid_list length", len(full_kid_list))
                    # print("child", child)
                    # this adds new kids to the full_kid_list
                    # and takes away kids from the still_check list
                    full_kid_list.append(child)
                    child_list = np.unique(sf.child[sf.parent == child].tolist())  # finds the kids
                    still_check = np.append(still_check, child_list)  # adds the kids to be checked
                    # delets the kid that was checked
                    still_check = np.delete(still_check, np.where(still_check == child))
                    # print("still_check after", still_check, "len", len(still_check))
                    # print("parent node", a, "new parent", child, "child(ren)", child_list)
                    # repeats the cycle
                    find_the_kids(a, still_check, temp_node_list,
                                  full_kid_list, for_next_sec, still_check, return_list)
            # print("full kid list", full_kid_list)
            # print("for_next_sec", for_next_sec, "length", len(for_next_sec))
            return_list.append((full_kid_list, for_next_sec))
            return return_list

        samplesize = 150
        alive_sam = np.random.choice(alive, samplesize)
        # samplesize = 1 # things for testing
        # alive_sam = [10283]
        print("alive_sam", alive_sam)
        node_list = []

        def partial_stop_point(stoping_gen):
            # take the year you would like to stop at and returns a list of nodes
            my_list_of_time = times < stoping_gen
            mid_list = my_nodes[my_list_of_time]
            temp_node_list = []
            for b in mid_list:
                temp_node_list.extend(ts.individual(b).nodes)
                # makes an ind a node to make a full list of nodes
            return temp_node_list

        def one_sec_at_a_time(alive_sam, temp_node_list):
            # make a dictinary of each node in the alive sample
            dictOfkids = dict.fromkeys(alive_sam, [])
            next_alive_sample = []  # for the next sample
            for a in alive_sam:
                return_list = []
                full_kid_list = []
                for_next_sec = []
                still_check = ()
                # full_kid_list_ind = np.array([], dtype=int)
                child_list = np.concatenate((np.unique(sf.child[sf.parent == a].tolist()), np.unique(
                    sf.child[sf.parent == a].tolist())))  # the first kids
                # print("parent nodes", node_list[0], node_list[1], "child(ren)", child_list)
                still_check = list(child_list)
                # print("the fist kids of ", a, " are ", still_check)
                ex = find_the_kids(a, child_list, temp_node_list,
                                   full_kid_list, for_next_sec, still_check, return_list)
                # ex is a list of list.
                # First list is the full_kid_list(nodes)
                # second list is the next generation for that initial node
                if ex != None:
                    full_kid_list_nodes = ex[0][0]
                    # full_kid_list_nodes = ex
                    # ones that are still alive individuals_alive_at
                    temp_sample = ex[0][1]
                    if len(full_kid_list_nodes) == 0:
                        if len(child_list) == 0:
                            continue
                        next_alive_sample = np.append(next_alive_sample, a)
                        # sometimes nodes dont have kids in a particalar year(s) so I add them back to the list
                        continue
                    if len(temp_sample) == 0:
                        next_alive_sample = np.append(next_alive_sample, a)
                        # next_alive_sample.append(a)
                    if len(temp_sample) != 0:
                        next_alive_sample = np.append(next_alive_sample, temp_sample)
                    # print(next_alive_sample)
                # print("full_kid_list_nodes", full_kid_list_nodes)
                    '''
                    for kid in full_kid_list_nodes:
                        # truns nodes into individuals
                        the_kids = int(nodes.individual[int(kid)])
                        # print("kid node", kid, "the_kid ind", the_kids)
                        full_kid_list_ind = np.append(full_kid_list_ind, the_kids)
                        '''
                # print("parent", a, "kids", full_kid_list_ind)
                # full_kid_list_ind.append(nodes.individual[kid])
                # print("full_kid_list_ind", full_kid_list_ind)
                # assert(np.all(full_kid_list_ind >= 0))
                    dictOfkids[int(a)] = np.unique(full_kid_list_nodes).tolist()
                #   dictOfkids[int(a)] = np.unique(full_kid_list_ind).tolist()
            dictOfkids["next"] = np.unique(next_alive_sample).tolist()
            return(dictOfkids)

        def indiv_2_nod(given_idv_list):
            # takes individulas and makes them nodes, but only keeps 1 od each ind nodes
            node_return = []
            for a in given_idv_list:
                # these are the nodes of my individuals alive at this time
                node_return.extend(ts.individual(int(a)).nodes)
            return node_return[1::2]

# next step will be to combine dictinarys
        count = 1
        alive_sam_l = indiv_2_nod(alive_sam)
        for part in Y:
            # looking at a smaller section
            # alive_sam_l needss to be in nodes
            print("part, ", part, "points, ", Y)
            dic_output = one_sec_at_a_time(
                alive_sam_l, partial_stop_point(timepoints - int(part)))
            alive_sam_l = np.array(dic_output["next"])
            '''
            node_list = np.array(dic_output["next"])
            alive_sam_l = []
            print("node_list ", node_list)
            for spot in node_list:
                alive_sam_l = np.append(alive_sam_l, int(nodes.individual[int(spot)]))
            print("part", part, "# of nodes", len(node_list), "# of idv", len(alive_sam_l),)
            '''
            dic_output.pop("next", None)
            if count == 1:
                dictOfkids = dic_output

            else:
                for key in dictOfkids:
                    match_list = set(dictOfkids[key]).intersection(list(dic_output.keys()))
                    add_more_kids = []
                    for match in match_list:
                        add_more_kids = add_more_kids + dic_output[match]
                    # adding the new nodes to the old node then making them individuals

                    dictOfkids[key] = list(dictOfkids[key]) + list(add_more_kids)
                    # print("key ", key, "length of kid nodes ", len(dictOfkids[key]))
            count += 1

        for key in dictOfkids:
            com_kid_list_nodes = dictOfkids[key]
            com_kid_list_ind = []
            for kid in com_kid_list_nodes:
                # truns nodes into individuals
                the_kids = int(nodes.individual[int(kid)])
                com_kid_list_ind = np.append(com_kid_list_ind, the_kids)
            dictOfkids[key] = com_kid_list_ind
        # print("dictOfkids", dictOfkids)
        # set(dictOfkids[key]) & set(dic_output*list of keys)

        # count += 1
        # print(count / len(alive_sam) * 100, "% done, # of decendents ", len(full_kid_list_ind))

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
                # print("key", key, "values", dictOfkids[int(key)])

                num_of_kids.append(len(set(dictOfkids[int(key)]) & set(inds_to_look_for)))
            return num_of_kids

        kidos = []
        existing_sam = []
        for year in reversed(range(0, timepoints, 1)):
            kid_num = kid_by_year(year, dictOfkids)
            kidos.append(kid_num)
        # print("kidos ", kidos)

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

        t = list(range(0, timepoints, 1))
        Pointsize = [10] * 3
        Points = np.zeros(samplesize, dtype=[('xy', float, 2)])
        ax.scatter(locs[alive_sam, 0], locs[alive_sam, 1])  # blue points
        ax.set_ylabel(filename)
        animation = FuncAnimation(fig, update, interval=600, frames=timepoints)
        scat = ax.scatter(0, 0,
                          s=1, edgecolors='none', color="red")

        animation.save('/Users/victoria/Desktop/test_' + filename + "_samplesize_" +
                       str(samplesize) + "_timepoints_" + str(timepoints) + '.gif', writer='imagemagick', fps=10)
    #        plt.show()
