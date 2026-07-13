#include <stdio.h>

__constant__  int  d_cvar;

__global__ void mykernel()
 { 
   printf("%d\n", d_cvar);
 } 

int main(void)  {

   int h_cvar=5;
   cudaMemcpyToSymbol(d_cvar, &h_cvar, sizeof(int));  //
   mykernel<<<2,128>>>(); 
   cudaDeviceSynchronize();
   return  0;
 }
