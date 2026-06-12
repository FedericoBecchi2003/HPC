#include <unistd.h>    //optarg
#include <time.h>      //gettime
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

void options(int argc, char * argv[]) ;
double f1 (long int);
double f2 (long int);

long n;
long int n_f1 =1000000000;    // intervalli
long int n_f2 =1000000000;
double h_f1; 
double h_f2; 
char hostname[100];

#define BILLION  1000000000L;

 struct timespec ta,tb;
 double tp_f1;
 double tp_f2; 
 double sum_f1;
 double sum_f2;
 double pi_f1;
 double pi_f2;

/********************************************/

int main( int argc, char *argv[])
{

    double  PI = 3.14159265358979323846264338327950288 ;
    double sum;

    gethostname(hostname, 100); 

    options(argc, argv);  /* optarg management */ 

    h_f1 = 1.0 / (double) n_f1;

   clock_gettime( CLOCK_REALTIME  , &ta); ////////////////////////////////

   sum = f1(n_f1); 

   clock_gettime( CLOCK_REALTIME , &tb); ////////////////////////////////

   pi_f1 = 4 * h_f1 * sum;

   tp_f1 = (double) ( tb.tv_sec  - ta.tv_sec )
       + (double) ( tb.tv_nsec - ta.tv_nsec )/ BILLION; // so the results is in ms
    
    clock_gettime( CLOCK_REALTIME  , &ta); ////////////////////////////////

   sum= f2(n_f2); 

   clock_gettime( CLOCK_REALTIME , &tb); ////////////////////////////////

   pi_f2 = 4 * h_f2 * sum;

   tp_f2 = (double) ( tb.tv_sec  - ta.tv_sec )
       + (double) ( tb.tv_nsec - ta.tv_nsec )/ BILLION; // so the results is in ms

        fprintf(stderr,"F1 #Inter       error       time(ms)        hostname \n");
    fprintf(stdout," %ld,  %.8e,  %.5f, %s \n",
                n_f2,  fabs(pi_f2-PI), tp_f2, hostname);

    fprintf(stderr,"F2 #Inter       error       time(ms)        hostname \n");
    fprintf(stdout," %ld,  %.8e,  %.5f, %s \n",
                n_f2,  fabs(pi_f2-PI), tp_f2, hostname);

    return 0;
}

double f1 (long int n )
 { 
    long int i; 
    double x, sum=0.0; 
    for (i = 1; i <= n; i++)
     {
       x = h_f1 * ((double)i - 0.5);
       sum += sqrt(1-x*x) ;
     }
     return sum; 
 }


double f2 (long int n )
 {
    long int i;
    double x, sum=0.0;
    for (i = 1; i <= n; i++)
     {
       x = h_f2 * ((double)i - 0.5);
       sum += (1.0 / (1.0 + x*x));
     }
     return sum;
 }



/************************************************/

void options(int argc, char * argv[]) 
{
  int i;
   while ( (i = getopt(argc, argv, "n:s:h")) != -1) {
        switch (i) 
        {
        case 'n':  n  = strtol(optarg, NULL, 10);  break;
        case 'h':  printf ("\n%s [-n intervals] [-h]",argv[0]); exit(1);
        default:   printf ("\n%s [-n intervals] [-h]",argv[0]); exit(1);
        }
    }
}

