import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt 
import pandas as pd
import numpy as np  # Imported for positioning

df = pd.read_csv("timing_cluster.csv", comment="#", sep="\\s+")

print(df.timer)

# 1. Create numeric positions for the bars (e.g., [0, 1])
x_positions = np.arange(len(df.timer))

# 2. Plot using the numeric positions
plt.title('Performance - "Timing Cluster" - Federico Becchi  05/06/2026')
plt.ylabel('seconds')
plt.bar(x_positions, df.time)

# 3. Replace the numbers on the x-axis with your actual text labels
plt.xticks(x_positions, df.timer)

# plt.xticks(rotation=45) # Uncomment if names overlap
plt.savefig('timing_Cluster.png')
