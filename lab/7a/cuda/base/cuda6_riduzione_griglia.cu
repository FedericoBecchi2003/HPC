#define DESCRIZIONE   "  \n\
Si vuole calcolare nella variabile c la riduzione somma di un array a[N]  \n\
utilizzando la memomria shared di blocchi da 32 thread (Grid_size = N/32) \n\
L'array a viene copiato sul Device; il Kernel copia l'array dalla memoria \n\
 globale a_d alla memoria shared a_s e ogni blocco esegue la riduzione somma. \n\
Il risultato di ogni blocco si trova nel primo elemento  ( a_s[0] )     \n\
Occorre fare una riduzione di secondo livello tra a_s[0] di ogni blocco  \n\
Possiamo eseguire una somma atomica:       atomicAdd (&c,a_s[0]);       \n\
 oppure  gestire una sezione critica:                                   \n\
 atomicCAS(&lock, 0, 1)); <sez. critica>   atomicExch(&lock, 0);      \n\
 Quale e' piu' veloce?                                                \n\n"

#include<stdio.h>
#define N 16777216
#define BSIZE 1024

int   __device__  lock=0;
float __managed__  c=0; 

__global__ void sum(float *a_d) {

__shared__ float a_s[BSIZE];  // shared 

a_s[threadIdx.x]=a_d[threadIdx.x+blockIdx.x*blockDim.x]; 
//printf("%d-%d-%.1f ", blockIdx.x, threadIdx.x, a_s[threadIdx.x]); 

  int i = BSIZE/2;
   __syncthreads();
   while (i != 0) {
         if (threadIdx.x < i)
         a_s[threadIdx.x] += a_s[threadIdx.x + i];
         __syncthreads();
         i /= 2;
   }
if (  threadIdx.x == 0 )        // sincronismo tra blocchi
   {

//   atomicAdd (&c,a_s[0]);

    do {} while(atomicCAS(&lock, 0, 1));    // spin
   // printf("Block %d thread %d entering critical section \n", blockIdx.x, threadIdx.x);
    c  += a_s[0];
   __threadfence();
   atomicExch(&lock, 0); // release lock 
   //printf("Block %d thread %d exiting critical section \n", blockIdx.x, threadIdx.x);

   }
 }



 float a[N];
 float *a_d;

int main()
{

 printf(DESCRIZIONE);


 for (int i=0; i<N; i++) a[i]=1.0; 

 cudaMalloc((void**)&a_d, N * sizeof(float));  // global
 cudaMemcpy(a_d, a, sizeof(float)*N , cudaMemcpyHostToDevice); 

 int GSIZE = (int)N/BSIZE; 
 printf("GRID:%d BLOCK:%d N:%d\n",GSIZE, BSIZE, N);

 sum<<<GSIZE,BSIZE>>>(a_d);
 cudaDeviceSynchronize();

 printf("c=%.1f\n", c);

 cudaFree(a_d); 
}
