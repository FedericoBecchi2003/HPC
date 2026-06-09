import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import pandas as pd

lat1 = pd.read_csv("results/Cluster/lat1-wn20.csv", comment="#", sep=r'\s+', names=["avgTround", "avgT"])
lat2 = pd.read_csv("results/Cluster/lat2-wn20.csv", comment="#", sep=r'\s+', names=["avgTround", "avgT"])

labels = ['Intra-nodo\n(wn20-wn20)', 'Inter-nodo\n(wn20-wn21)']
values = [float(lat1.avgT.iloc[0]), float(lat2.avgT.iloc[0])]

plt.figure(figsize=(6, 5))
plt.title('Network Latency (one-way) - Federico Becchi 08/06/2026')
plt.grid(axis='y')
plt.ylabel('Latenza one-way (µs)')
bars = plt.bar(labels, values, color=['steelblue', 'tomato'], width=0.4)
for bar, val in zip(bars, values):
    plt.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 0.02,
             f'{val:.2f} µs', ha='center', va='bottom', fontsize=11)
plt.ylim(0, max(values) * 1.4)
plt.tight_layout()
plt.savefig('results/Cluster/lat.png', dpi=150)
