from glob import glob
import pandas as pd

# 1. Importa prima SOLO matplotlib base
import matplotlib

# 2. Imposta il backend AGG (prima di pyplot!)
matplotlib.use("Agg")

# 3. Ora puoi importare pyplot in sicurezza
import matplotlib.pyplot as plt

filenames = glob("*mm*.csv")

dfs = []
for filename in filenames:
    dfs.append(
        pd.read_csv(
            filename,
            comment="#",
            names=["N", "gflop", "tempo", "GFLOPs", "Hostname", "opt", "nt"],
        )
    )

# Concatenate all data into one DataFrame
df = pd.concat(dfs, ignore_index=True)

print(df)

# Creazione del grafico
df.plot(kind="bar", x="opt", y="GFLOPs", stacked=True, legend=True)

plt.title('Performance CPU cluster matrixMul" Federico Becchi 06-06-2026')
plt.legend()
plt.yscale("log")
plt.ylabel("GFLOP/s")
plt.tight_layout()
plt.savefig("matrixMul.png")
