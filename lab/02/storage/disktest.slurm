#!/bin/sh

#SBATCH --job-name=disktest
#SBATCH --partition=cpu_guest
#SBATCH --qos=cpu_guest
##SBATCH --nodelist=wn18
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
##SBATCH --mem=2G
#SBATCH --time=0-00:10:00

echo "#SLURM_JOB_NODELIST: $SLURM_JOB_NODELIST"

DISKTEST=~/HPC2526/2-Performance/storage/disktest.sh

if [ ! -f "$DISKTEST" ]; then
    echo "ERROR: disktest.sh not found at $DISKTEST"
    exit 1
fi

echo "####################################"
echo "# HOME perf"
cd $HOME && pwd
cp $DISKTEST .
sh disktest.sh

echo "####################################"
echo "# SCRATCH perf"
if [ -z "$SCRATCH" ]; then
    echo "SCRATCH not defined, skipping"
else
    cd $SCRATCH && pwd
    cp $DISKTEST .
    sh disktest.sh
fi

echo "####################################"
echo "# ARCHIVE perf"
if [ -z "$ARCHIVE" ]; then
    echo "ARCHIVE not defined, skipping"
else
    cd $ARCHIVE && pwd
    cp $DISKTEST .
    sh disktest.sh
fi

echo "####################################"


