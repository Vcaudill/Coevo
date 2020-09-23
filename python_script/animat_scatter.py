import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation


def updata(frame_number):
    current_index = frame_number % 4
    print("For Dataset", current_index)
    a = [[10, 20, 30], [40, 50, 60], [70, 80, 90], [50, 80, 70]]
    Points['xy'][:, 0] = np.asarray(a[current_index])
    Points['xy'][:, 1] = np.asarray(a[current_index])
    Pointsize = a[current_index]
    scat.set_sizes(Pointsize)
    scat.set_offsets(Points['xy'])
    # scat.set_offsets(Pointsize)
    # scat.set_offsets(Points['xy'],Pointsize)
    ax.set_xlabel('x')
    ax.set_ylabel('y')
    ax.set_title("For Dataset %d" % current_index)


fig = plt.figure(figsize=(5, 5))
ax = fig.add_subplot(111)
Points = np.zeros(3, dtype=[('xy', float, 2)])
Pointsize = [10] * 3
scat = ax.scatter(Points['xy'][:, 0], Points['xy'][:, 1], s=Pointsize, alpha=0.3, edgecolors='none')
ax.set_xlim(0, 100)
ax.set_ylim(0, 100)
animation = FuncAnimation(fig, updata, frames=50, interval=600)
plt.show()
