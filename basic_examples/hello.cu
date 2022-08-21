#include<stdio.h>

#define BLOCKS 1
#define GPU_THREADS_PER_BLOCK 16

__global__ void helloFromGPU(void)
{
    printf("Hello from GPU!\n");
}

int main(void)
{
    printf("Hello from CPU!\n\n");

    helloFromGPU <<<BLOCKS, GPU_THREADS_PER_BLOCK>>>();
    cudaDeviceReset();

    return 0;
}