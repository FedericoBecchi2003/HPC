#include <stdio.h>
#include <math.h>
#include <unistd.h>    //optarg
#include <time.h>

#define BILLION  1000000000L;

void options(int argc, char * argv[]) ;

int n=500000000;           // default intervalli
int nblocks=128;           // default numero blocchi
int threadsPerBlock=1024;  // default thread per blocco

const double  PI = 3.14159265358979323846264338327950288 ;

__global__ void add( float *res2 ) {

     long int tid = threadIdx.x + blockIdx.x * blockDim.x;

     double h = 1.0 / (double)(gridDim.x * blockDim.x);
     double x = h * ((double)tid - 0.5);
     double pi2 = (1.0 / (1.0 + x*x)); // f2
     res2[tid] = pi2 * 4 * h;

    __syncthreads();
    // for reductions, threadsPerBlock must be a power of 2 // because of the following code
    int i = blockDim.x/2;
    __syncthreads();
    while (i != 0) {
   	 if (threadIdx.x < i)
	 res2[tid] += res2[tid + i];
	 __syncthreads();
	 i /= 2;
         }
}

/************************************************/

int main(int argc, char **argv ) {

    options(argc, argv);  /* optarg management */

    n=nblocks*threadsPerBlock;

    float* res2=(float*)malloc(n*sizeof(float));
    float *dev_res2;
    cudaMalloc( (void**)&dev_res2, n*sizeof(float) );

    struct timespec t1,t2,t3,t4;
    double wtime, ktime, mtime;  // WallTime, KernelTime, MemcopyTime

    clock_gettime( CLOCK_REALTIME ,          &t1) ;

    add<<<nblocks,threadsPerBlock>>>( dev_res2 );
    cudaDeviceSynchronize();
    clock_gettime( CLOCK_REALTIME ,          &t2) ;

    cudaMemcpy( res2, dev_res2, n*sizeof(float), cudaMemcpyDeviceToHost );
    clock_gettime( CLOCK_REALTIME ,          &t3) ;

    float total2=0;
    for (long int i=0;i<n;i+=threadsPerBlock)  total2+=res2[i];

    clock_gettime( CLOCK_REALTIME ,          &t4 ) ;

    wtime = (double) ( t4.tv_sec  - t1.tv_sec )
          + (double) ( t4.tv_nsec - t1.tv_nsec )
            / BILLION;

    mtime = (double) ( t3.tv_sec  - t2.tv_sec )
          + (double) ( t3.tv_nsec - t2.tv_nsec )
            / BILLION;

    ktime = (double)  ( t2.tv_sec  - t1.tv_sec )
           + (double) ( t2.tv_nsec - t1.tv_nsec )
            / BILLION;

    fprintf(stderr,"#intervals blocks pi error wtime(s) mtime(s) ktime(s) \n");
    fprintf(stderr,"CUDA, %d, %d, %d, %.10f, %.10e, %.4f,  %.4f, %.4f \n", 
          n, nblocks, threadsPerBlock, total2,  fabs(total2 - PI), wtime, mtime, ktime);

    cudaFree( dev_res2 );

    return 0;
}


/************************************************/

void options(int argc, char * argv[])
{
   int i;
   while ( (i = getopt(argc, argv, "t:b:h")) != -1) {
        switch (i)
        {
        case 'b':  nblocks         = strtol(optarg, NULL, 10);  break;
        case 't':  threadsPerBlock = strtol(optarg, NULL, 10);  break;
        case 'h':  printf ("\n%s [-b blocks] [-h]",argv[0]); exit(1);
        default:   printf ("\n%s [-b blocks] [-h]",argv[0]);  exit(1);
        }
   }
}

