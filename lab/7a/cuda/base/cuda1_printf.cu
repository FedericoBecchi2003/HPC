#define DESCRIZIONE   "  \n\
Ogni thread stampa le coordinate del blocco nella gliglia \n\
e le  proprie coordinate all interno del blocco.          \n\n"

#define MAX 1024

#include <stdio.h>

__global__ void print_kernel()
   { if ( blockIdx.x == MAX-1 ) printf("Hello from block %d/%d, thread %d/%d\n", blockIdx.x, gridDim.x, threadIdx.x, blockDim.x);  }

int main() {
   printf(DESCRIZIONE);
   print_kernel<<<MAX,1024>>>();
   cudaDeviceSynchronize();
}
