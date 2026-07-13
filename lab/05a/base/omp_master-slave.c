// gcc -fopenmp omp_master-slave.c -o omp_master-slave

#include <stdio.h>
#include <omp.h>

int main(int argc, char* argv[])
{

 omp_set_nested(1); // PARALLELISMO ANNIDATO

 #pragma omp parallel private(i) num_threads(2) // CREAZIONE REGIONE PARALLELA 2 THREAD
 {
  #pragma omp sections
    {
       #pragma omp section   // MASTER
         {
          printf("Master %d/%d \n",omp_get_thread_num(),omp_get_num_threads());
         }
       #pragma omp section  // SLAVES
         {
         #pragma omp parallel for num_threads(7)  // nested parallel region
          for(i = 0; i < 8; i++)
           printf("Thr %d/%d : %d \n",omp_get_thread_num(),omp_get_num_threads(),i);
         }
    } // end sections 
  } // end parallel 
}