import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import pandas as pd

band1 = pd.read_csv("results/Cluster/band1-wn20.csv", comment="#", sep=r'\s+', names=["bytes", "MBps"])
band2 = pd.read_csv("results/Cluster/band2-wn20.csv", comment="#", sep=r'\s+', names=["bytes", "MBps"])

plt.figure(figsize=(8, 5))
plt.title('Network Bandwidth - Federico Becchi 08/06/2026')
plt.grid(True)
plt.xlabel('Message size (bytes)')
plt.ylabel('Bandwidth (MB/s)')
plt.plot(band1.bytes, band1.MBps, 'bo-', label='Intra-nodo (wn20-wn20)')
plt.plot(band2.bytes, band2.MBps, 'ro-', label='Inter-nodo (wn20-wn21)')
plt.legend(loc='upper left')
plt.tight_layout()
plt.savefig('results/Cluster/band.png', dpi=150)
