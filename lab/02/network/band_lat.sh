#!/bin/sh

# Recuperiamo l'hostname del Mac per il file di output finale
HOSTNAME=$(hostname)

OUT="results/PC/"
mkdir -p "$OUT"

echo "Avvio dei test HPC nei container Docker..."

# Lanciamo mpirun DENTRO il container wn1 (usando il suo mpirun nativo),
# ma pilotandolo comodamente dal terminale del tuo Mac.
docker compose exec -w /root/02/network wn1 mpirun --allow-run-as-root -npernode 2 -np 2 -host wn1:4       ./mpi_bandwidth 2> "$OUT/band1-$HOSTNAME.csv"
docker compose exec -w /root/02/network wn1 mpirun --allow-run-as-root -npernode 1 -np 2 -host wn1:4,wn2:4 ./mpi_bandwidth 2> "$OUT/band2-$HOSTNAME.csv"

docker compose exec -w /root/02/network wn1 mpirun --allow-run-as-root -npernode 2 -np 2 -host wn1:4       ./mpi_latency   2> "$OUT/lat1-$HOSTNAME.csv"
docker compose exec -w /root/02/network wn1 mpirun --allow-run-as-root -npernode 1 -np 2 -host wn1:4,wn2:4 ./mpi_latency   2> "$OUT/lat2-$HOSTNAME.csv"

echo "Test completati con successo!"
echo "I file CSV con i risultati sono pronti nella cartella del tuo Mac."