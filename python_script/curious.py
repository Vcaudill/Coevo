import sys
import pyslim
import tskit
import numpy as np
# import spatial_slim as sps

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.animation as ani
import matplotlib.collections as cs


def animate_lineage(ts, children, positions, num_steps):
    """
    An animation of the lineages ancestral to the given children
    at the given positions.
    """
    fig = plt.figure(figsize=(9, 9))
    ax = fig.add_subplot(111)
    locs = ts.individual_locations
    xmax = np.ceil(max(locs[:, 0]))
    ymax = np.ceil(max(locs[:, 1]))
    ax.set_xlim(0, xmax)
    ax.set_ylim(0, ymax)

    def colormap(x): return plt.get_cmap("cool")(x / max(ts.individual_ages))
    treecolors = [plt.get_cmap("viridis")(x) for x in np.linspace(0, 1, len(positions))]

    inds = ts.individuals_alive_at(0)
    circles = ax.scatter(locs[inds, 0], locs[inds, 1], s=10,
                         edgecolors=colormap([0 for _ in inds]),
                         facecolors='none')
    # will record here tuples of the form (time, x, y)
    # and will later add the given lines at the corresponding times
    nodes = np.concatenate([ts.individual(i).nodes for i in children])
    node_times = ts.tables.nodes.time
    node_indivs = ts.tables.nodes.individual
    paths = []
    for p in positions:
        tree = ts.at(p)
        for u in nodes:
            out = [np.concatenate([[node_times[u]], locs[node_indivs[u], :2]])]
            u = tree.parent(u)
            while u is not tskit.NULL:
                uind = node_indivs[u]
                if uind is tskit.NULL:
                    break
                out.append(np.concatenate([[node_times[u]], locs[uind, :2]]))
                u = tree.parent(u)
            paths.append(np.row_stack(out))
    pathcolors = []
    for c in treecolors:
        pathcolors.extend([c] * num_positions)
    lc = cs.LineCollection([], linewidths=0.5, colors=pathcolors)
    ax.add_collection(lc)

    def update(frame):
        inds = ts.individuals_alive_at(frame)
        circles.set_offsets(locs[inds, :2])
        # color based on age so far
        circles.set_color(colormap(ts.individual_ages_at(frame)[inds]))
        show_paths = []
        for path in paths:
            dothese = (path[:, 0] <= frame)
            show_paths.append(path[dothese, 1:])
        lc.set_paths(show_paths)
        return circles, lc

    animation = ani.FuncAnimation(fig, update,
                                  frames=np.linspace(0, num_steps, num_steps + 1))
    return animation


# treefile = sps.run_slim(script = script, **kwargs)
treefile = "sim.trees"
outbase = ".".join(treefile.split(".")[:-1])

ts = pyslim.load(
    '/Users/victoria/Desktop//Rotation_2020/bias_test_data/Bias_0.15_sigma_0.8_ID_1602158267717_late_100_.trees')

today = np.where(ts.individual_times == 0)[0]
num_indivs = 1
num_positions = 5
num_steps = 1000
animation = animate_lineage(ts,
                            np.random.choice(today, num_indivs),
                            np.random.randint(0, ts.sequence_length - 1, num_positions),
                            #[33333],
                            num_steps)
#animation.save(outbase + ".lineages.mp4", writer='writer')
animation.save('/Users/victoria/Desktop/myAnimation_1.gif',
               writer='imagemagick', fps=30)
