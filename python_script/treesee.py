import sys
import tskit
import pandas as pd
import msprime as msp
import numpy as np
import multiprocessing as mp
import subprocess as sp
import pyslim
import os
import io
import shutil
import shlex
import scipy
import time
import re
from shutil import copyfile
import allel
import time
from scipy import spatial
from scipy import stats
from tqdm import tqdm
import itertools
import matplotlib.pyplot as plt
import scipy.sparse as sparse
from collections import defaultdict


for filename in os.listdir('/Users/victoria/Desktop/Rotation_2020/bias_test_data/'):
    if filename.endswith(".trees"):

        myfile = filename.split(".trees")[0]
        print(myfile)
        # tree = pyslim.SlimTreeSequence.load('/Users/victoria/Desktop/biased_mig/trees/' + filename)
        tree_sequence = tskit.TreeSequence.load(
            '/Users/victoria/Desktop/Rotation_2020/bias_test_data/' + filename)
        ts = pyslim.load('/Users/victoria/Desktop/Rotation_2020/bias_test_data/' + filename)


# for order in ["preorder", "inorder", "postorder"]:
#    print(f"{order}:\t", list(tree.nodes(order=order)))

# print(len(tree.first_generation_individuals()))
# print(tree.individual(1000))


# tree_sequence = msp.simulate(sample_size=6, Ne=1000)
# stdoutOrigin = sys.stdout
# sys.stdout = open("/Users/victoria/Desktop/log.txt", "w")

tree = tree_sequence.first()
# print(tree.draw(format="unicode"))

# sys.stdout.close()
# sys.stdout = stdoutOrigin
'''
u = 126758
while u != tskit.NULL:
    print("node {}: time = {}".format(u, tree.time(u)))
    u = tree.parent(u)

n = 6740
while n != tskit.NULL:
    print("node {}: time = {}: num of kids = {}: kids {}".format(
        n, tree.time(n), len(tree.children(n)), (tree.children(n))))
    if len(tree.children(n)) != 0:
        n = list(tree.children(n))[0]
    else:
        n = tskit.NULL


# print(tskit.TableCollection(1))
print(np.where(ts.individual_times == 0)[0])
print(ts.sequence_length)

print(ts.slim_generation)'''
# Returns an array giving the IDs of all individuals that are known to be alive at the given time ago.
alive = ts.individuals_alive_at(0)

print(f"There are {len(alive)} individuals alive from the final generation.")

indiv_types = {"first_gen": 0,
               "remembered": 0,
               "alive": 0}
for ind in ts.individuals():
    if ind.flags & pyslim.INDIVIDUAL_FIRST_GEN:
        indiv_types['first_gen'] += 1
    if ind.flags & pyslim.INDIVIDUAL_REMEMBERED:
        indiv_types['remembered'] += 1
    if ind.flags & pyslim.INDIVIDUAL_ALIVE:
        indiv_types['alive'] += 1

for k in indiv_types:
    print(f"Number of individuals that are {k}: {indiv_types[k]}")
'''
print(ts.individual(6740).location)
print(ts.individual(6740).metadata)
print(ts.individual(19126).location)
print(ts.individual(19126).metadata)
print(tree_sequence.individual(10))
'''

mytable = tree_sequence.dump_tables()
# print(mytable.link_ancestors(ts.individuals_alive_at(50), alive))
# locatios are x and y amd z?


def relatedness_matrix(self, left=0.0, right=None):
    if right is None:
        right = self.sequence_length
    edges = self.tables.edges
    R = sparse.coo_matrix((np.fmin(right, edges.right) - np.fmax(left, edges.left),
                           (edges.parent, edges.child)),
                          shape=(self.num_nodes, self.num_nodes), dtype='float')

    return R.tocsc()


"""
Constructs the sparse matrix whose [i,j]th entry gives the amount that node j
inherited *directly* from node i, i.e., the sum of the length of all edges
that have i as a parent and j as a child.
"""


def relatedness(self, focal_nodes, max_hops):
    X = (relatedness_matrix(self) > 0)
    Xt = X.transpose()
    out = np.repeat(np.inf, self.num_nodes)
    out[focal_nodes] = 0
    x = np.repeat(0.0, self.num_nodes)
    x[focal_nodes] = 1.0
    for n in range(1, max_hops + 1):
            # n is the number of up-hops
        x = X.dot(x)
        y = x.copy()
        out[y > 0] = np.fmin(out[y > 0], n)
        for k in range(1, max_hops + 1 - n):
                # k is the number of down-hops
            y = Xt.dot(y)
            # now y[j] is the number of paths of length n + k
            #  that go from any focal node to j.
            out[y > 0] = np.fmin(out[y > 0], n + k)
    return out


"""
For each node, find the smallest number of genealogical hops to one of focal_nodes.
"""


# print("matrix", relatedness_matrix(tree_sequence) != relatedness_matrix(ts))
# these matrixes are the same!
# print("matrix", relatedness_matrix(ts) > 0)
# print("txt", True * True)
# print("fxf", False * False)
'''print("RM", relatedness_matrix(ts)[0])
print("RM", relatedness_matrix(ts)[0][0])
print(relatedness_matrix(ts).shape, "?", ts.num_nodes)'''
# wrt = relatedness(ts, ts.individuals_alive_at(0), 100)
# how does relatedness and the matix work?
'''
k = 33333
wrt = relatedness(ts, k, 1)
new_arr = wrt[wrt < 1E308]
print("1 hop, len ", len(new_arr), new_arr)
wrt = relatedness(ts, k, 2)
new_arr = wrt[wrt < 1E308]
print("2 hop, len ", len(new_arr), new_arr)
wrt = relatedness(ts, k, 3)
new_arr = wrt[wrt < 1E308]
print("3 hop, len ", len(new_arr), new_arr)
wrt = relatedness(ts, k, 4)
new_arr = wrt[wrt < 1E308]
print("4 hop, len ", len(new_arr), new_arr)

wrt = relatedness(ts, k, 60)
new_arr = wrt[wrt < 1E308]
print("60 hop, len ", len(new_arr), np.unique(new_arr))
'''
'''print(ts.individual(k).metadata)
print("len wtr", len(wrt))
print(ts.num_nodes)
print(len(ts.individuals_alive_at(0)))
new_arr = wrt[wrt < 1E308]
print(new_arr)
print(len(new_arr))'''
'''
for i in new_arr:
    print("relate", i)
'''


# print(np.random.randint(0, ts.sequence_length - 1, 3))

today = np.where(ts.individual_times == 0)[0]  # year you want to end "they are alive today"
ind_then = np.where(ts.individual_times == 10)[0]  # year you want to begin
print("this is today", today, "today length", len(today))
#alive = ts.individuals_alive_at(0)
alive = np.where(ts.individual_times == 99)[0]
#print("this is alive", alive, "alive length", len(alive))
inds = ts.individuals_alive_at(99)
#print("inds", inds, "length", len(inds))
edges = ts.tables.edges
#print("the first edge", edges[0])
# print("the child", edges.child, "length", len(edges.child))
#print("the child", edges.child[0])
#print("the parent", edges.parent[0])
# print(len(edges))
children = np.random.choice(today, 5)
# print(children)
#[print(ts.individual(i).nodes) for i in children]

nodes = np.concatenate([ts.individual(i).nodes for i in today])
# print(nodes)

# dataframe of all parent/child nodes from the edge table
child = edges.child
parent = edges.parent
dt = {"parent": parent, "child": child}
sf = pd.DataFrame(dt)
#print("the head", sf.head())
#print("the child node", np.unique(sf.child[sf.parent == 229906].tolist()))
#print("parent node", np.unique(sf.parent[sf.child == 233329].tolist()))


def find_the_kids(a, child_list):
    for child in child_list:
        if child not in full_kid_list:
            child_list = np.unique(sf.child[sf.parent == child].tolist())
            full_kid_list.append(child)
            #print("parent node", a, "new parent", child, "child(ren)", child_list)
            find_the_kids(a, child_list)
            # print("full kid list", full_kid_list)
    return full_kid_list


alive_sam = np.random.choice(alive, 30)
print("alive_sam", alive_sam)
node_list = []
for i in alive_sam:
    # these are the nodes of my individuals alive at this time
    node_list.extend(ts.individual(i).nodes)


nodes = ts.tables.nodes
dictOfkids = dict.fromkeys(alive_sam, [])
print(dictOfkids)
for a in alive_sam:
    node_list = []
    # these are the nodes of my individuals alive at this time
    node_list.extend(ts.individual(a).nodes)
    #print("node_list", node_list)
    full_kid_list = []
    child_list = np.concatenate((np.unique(sf.child[sf.parent == node_list[0]].tolist()), np.unique(
        sf.child[sf.parent == node_list[1]].tolist())))
    #print("parent nodes", node_list[0], node_list[1], "child(ren)", child_list)
    full_kid_list_nodes = find_the_kids(a, child_list)
    full_kid_list_ind = np.array([])
    #print("full_kid_list_nodes", full_kid_list_nodes)

    for kid in full_kid_list_nodes:
        the_kids = int(nodes.individual[int(kid)])
        #print("kid node", kid, "the_kid ind", the_kids)
        full_kid_list_ind = np.append(full_kid_list_ind, the_kids)
    print("parent", a, "kids", full_kid_list_ind)
    # full_kid_list_ind.append(nodes.individual[kid])
    #print("full_kid_list_ind", full_kid_list_ind)
    #assert(np.all(full_kid_list_ind >= 0))
    dictOfkids[a] = np.unique(full_kid_list_ind).tolist()

individual_nodes = []
num_of_kids = []
#print("alive_sam", alive_sam)
inds_to_look_for = ts.individuals_alive_at(30)
'''
for year in range(9, 100, 10):
    inds_to_look_for = np.where(ts.individual_times == year)[0]
    for key in dictOfkids:
        individual_nodes.append(key)
        print("key", key, "values", dictOfkids[key])
        num_of_kids.append(len(set(dictOfkids[key]) & set(inds_to_look_for)))
'''
print("how many", len(inds_to_look_for), "inds_to_look_for", inds_to_look_for)
for key in dictOfkids:
    individual_nodes.append(key)
    print("key", key, "values", dictOfkids[key])
    num_of_kids.append(len(set(dictOfkids[key]) & set(inds_to_look_for)))

print("individual_parents", alive_sam, "num_of_kids", num_of_kids)
print(max(num_of_kids), sum(num_of_kids))
s = [n / sum(num_of_kids) * 100 for n in num_of_kids]
fig = plt.figure(figsize=(9, 9))
ax = fig.add_subplot(111)
locs = ts.individual_locations
xmax = np.ceil(max(locs[:, 0]))
ymax = np.ceil(max(locs[:, 1]))
ax.set_xlim(0, xmax)
ax.set_ylim(0, ymax)

ax.scatter(locs[alive_sam, 0], locs[alive_sam, 1], s=s)
plt.show()

# make dataframe smaller by only having unique vales
# make a np array for all the children and loop searching from node values in this dictinary
# it is also possible to fin the location and use the orginal table and location to find the nodes
# take each node form the "beginning" and a lsit of children andthen see how many are currently alive
