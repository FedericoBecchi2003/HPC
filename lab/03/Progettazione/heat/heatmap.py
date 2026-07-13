import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from numpy import genfromtxt

a = genfromtxt('heatmap.txt', delimiter=' ')

cmaps = ['hot', 'viridis', 'coolwarm', 'inferno']

for cmap in cmaps:
    plt.figure()
    im = plt.imshow(a, cmap=cmap)
    plt.colorbar(im, label='Temperatura')
    plt.title(f'Heatmap ({cmap})')
    plt.savefig(f'heatmap_{cmap}.png')
    plt.close()
