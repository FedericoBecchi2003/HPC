#include <stdio.h>
#include <omp.h>

int main(int argc, char* argv[])
{
 int i,j; 
 int tid; // thread id 

 omp_set_num_threads(4);
        
 #pragma omp parallel  private(i,tid)
 {
   tid=omp_get_thread_num();

   //static = distribuzione decisa a compile-time/inizio, non dinamica (nessun overhead di runtime)
   #pragma omp for schedule(static,1)  // 1 chunckzie
   
   //#pragma omp for schedule(static,1) collapse(2) //  collpase due fa collasae i due for successevi in unuunico
   //senza collpase OPENMP Parellismo solo su I 
   for(j=0; j<4; j++)
    for(i=0; i<4; i++)
      printf("Esecuzione del thread %d:   j=%d i=%d \n", tid, j, i);

   printf("%d ha finito\n", tid);
 }
return 0;
}

