#include<stdio.h>

#define ARRAY_SIZE 16
#define BLOCKS 1
#define VALUE_1 900
#define VALUE_2 99

__global__ void sumNumbers(const int * d_input1, const int * d_input2, int * d_output)
{
    int index = threadIdx.x;
    d_output[index] = d_input1[index] + d_input2[index];
}

int h_input1[ARRAY_SIZE];
int h_input2[ARRAY_SIZE];
int h_output[ARRAY_SIZE];

int main(void)
{
    const int ARRAY_BYTES = ARRAY_SIZE * sizeof(int);

    for(int i = 0; i < ARRAY_SIZE; i++)
    {
        h_input1[i] = VALUE_1;
        h_input2[i] = VALUE_2;
    }

    int * d_input1 = NULL;
    int * d_input2 = NULL;
    int * d_output = NULL;
    
    //allocate memory on GPU
    cudaMalloc( (void**) &d_input1, ARRAY_BYTES);
    cudaMalloc( (void**) &d_input2, ARRAY_BYTES);
    cudaMalloc( (void**) &d_output, ARRAY_BYTES);

    //transfer data to GPU
    cudaMemcpy(d_input1, h_input1, ARRAY_BYTES, cudaMemcpyHostToDevice);  
    cudaMemcpy(d_input2, h_input2, ARRAY_BYTES, cudaMemcpyHostToDevice);
    
    //launch CUDA kernel 
    sumNumbers<<<BLOCKS, ARRAY_SIZE>>>(d_input1, d_input2, d_output);   

    //transfer result back to the application data section
    cudaMemcpy(h_output, d_output, ARRAY_BYTES, cudaMemcpyDeviceToHost);
    
    //print the result
    for(int i = 0; i < ARRAY_SIZE; i++)
    {
        printf("%d\n", h_output[i]);
    }

    cudaFree(d_input1);
    cudaFree(d_input2);
    cudaFree(d_output);
    
    cudaDeviceReset();           

    return 0;
}