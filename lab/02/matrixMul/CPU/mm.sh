#!/bin/sh

N=1024
#N=2048

OPT="-O2"
#OPT="-O3"

HOSTNAME=$(hostname)
FILENAME=mm.$HOSTNAME.csv

gcc  $OPT -o mm mm.c -I/opt/homebrew/opt/gsl/include -L/opt/homebrew/opt/gsl/lib -lgsl -lgslcblas

./mm    -n $N -c gcc-$HOSTNAME        > $FILENAME    # gcc       
./mm -g -n $N -c gcc+gsl-$HOSTNAME    >> $FILENAME   # gcc + gsl