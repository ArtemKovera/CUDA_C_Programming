#include<stdio.h>

#define BLOCKS 3
#define GPU_THREADS_PER_BLOCK 4

__global__ void exploringBlocks()
{
    printf("Block ID = %d,  Thread ID = %d\n", blockIdx.x, threadIdx.x);
}

int main()
{
    exploringBlocks <<<BLOCKS, GPU_THREADS_PER_BLOCK>>>();
        
    cudaDeviceSynchronize();

    return 0;
}