
import csv
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

'''
So I have been geeting an error: 

AttributeError: 'float' object has no attribute 'sqrt'

The above exception was the direct cause of the following exception:

Traceback (most recent call last):
  File "tv_path_percentage.py", line 136, in <module>
    str(sample_size) + "_timepoints_" + str(ts.slim_generation) + '.gif', writer='imagemagick', fps=10)
  File "/home/vcaudill/kernlab/miniconda3/envs/animate/lib/python3.7/site-packages/matplotlib/animation.py", line 1141, in save
    anim._draw_next_frame(d, blit=False)
  File "/home/vcaudill/kernlab/miniconda3/envs/animate/lib/python3.7/site-packages/matplotlib/animation.py", line 1176, in _draw_next_frame
    self._draw_frame(framedata)
  File "/home/vcaudill/kernlab/miniconda3/envs/animate/lib/python3.7/site-packages/matplotlib/animation.py", line 1726, in _draw_frame
    self._drawn_artists = self._func(framedata, *self._args)
  File "tv_path_percentage.py", line 109, in update
    scat.set_sizes(np.array(Pointsize))
  File "/home/vcaudill/kernlab/miniconda3/envs/animate/lib/python3.7/site-packages/matplotlib/collections.py", line 922, in set_sizes
    scale = np.sqrt(self._sizes) * dpi / 72.0 * self._factor
TypeError: loop of ufunc does not support argument 0 of type float which has no callable sqrt method

This error is strange because it pops up in sometimes and I dont really know why
It happens in the bias mig animation. when i readust pointsize
I have saved the decednts matrix as a CSV so that i can try to graph it with random locations

'''

kidos = []
filename = "Bias_0_sigma_0.35_ID_3152505412248_late_500__samplesize_6125.0_timepoints_500"
with open('/Users/victoria/Desktop/sort_dub/csv/Bias_0_sigma_0.35_ID_3152505412248_late_500__samplesize_6125.0_timepoints_500.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    for row in csv_reader:
        kidos.append(np.array(row).astype(np.float))
print(len(kidos[0]))

location = list(range(len(kidos[0])))
average = kidos[0][np.nonzero(kidos[0])].mean()
print(average)


def update(frame_number):
        # for year in range(9, 100, 10):
    year = frame_number % len(kidos)
    print(year)
    # means = statistics.mean(kidos[year])
    average = kidos[year][np.nonzero(kidos[year])].mean()
    Pointsize = np.ma.masked_equal((kidos[year] / average) * 10, 0)
    scat.set_sizes(np.array(Pointsize))
    # scat.set_offsets(locs[alive_sam, 0], locs[alive_sam, 1])
    Points['xy'][:, 0] = location
    Points['xy'][:, 1] = location
    print(Pointsize)
    scat.set_sizes(Pointsize)
    scat.set_offsets(Points['xy'])
    scat.set_array(np.array(kidos[year]))
    ax.set_title("Generation %d" % year)


fig = plt.figure(figsize=(9, 9))
ax = fig.add_subplot(111)

xmax = np.ceil(max(location))
ymax = np.ceil(max(location))
ax.set_xlim(0, xmax)
ax.set_ylim(0, ymax)

t = list(range(0, len(kidos), 1))
Pointsize = [10] * 3
Points = np.zeros(len(kidos[0]), dtype=[('xy', float, 2)])
# ax.scatter(locs[ind_to_plot, 0], locs[ind_to_plot, 1])  # blue points
ax.set_ylabel("file that failed_" + filename)
animation = FuncAnimation(fig, update, interval=600, frames=len(kidos))
scat = ax.scatter(0, 0,
                  s=1, edgecolors='none', color="red")
animation.save('/Users/victoria/Desktop/fail_test_' + filename + "_samplesize_" +
               str(len(kidos)) + "_timepoints_" + str(len(kidos)) + '.gif', writer='imagemagick', fps=10)
