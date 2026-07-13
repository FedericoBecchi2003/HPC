#!/bin/bash

#SBATCH --output=%x.%j.out   # Nome del file per lo strandard output
##SBATCH --error=%x.%j.err   # Se non specificato stderr e' rediretto su stdout
#SBATCH --partition=cpu_guest        # Nome della partizione
#SBATCH --qos=cpu_guest              # 
#SBATCH --ntasks=1                   # numero di processi da attivare
##SBATCH --mem=2G                    # massima memoria utilizzata
#SBATCH --time=0-00:02:00            # massimo tempo di calcolo
##SBATCH --account=T_2025_HPCPROGPAR  # Account da usare 
## Su login il comando hpc-show-user-account mostra gli account personali
## Per gli studenti del corso il default e' T_2025_HPCPROGPAR

# informazioni sull'ambiente Slurm
env | grep SLURM

# da eseguire su login per visualizzare
# i nodi disponibili nella partizione cpu_guest:

hpc-sinfo-cpu --partition=cpu_guest


# informazioni sul nodo di esecuzione

hostname
lscpu

# info piu' dettagliate sulla CPU:
cat /proc/cpuinfo

#dettaglio archtettura  NUMA (apt install numactl):
numactl --hardware
