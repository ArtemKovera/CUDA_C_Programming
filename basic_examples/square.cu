#include<stdio.h>

#define ARRAY_SIZE 64

__global__ void square (float * d_output, float * d_input)
{
    int index = threadIdx.x;
    float element = d_input[index];
    d_output[index] = element * element;
}

float h_input[ARRAY_SIZE];
float h_output[ARRAY_SIZE]; 

int main(void)
{
    const int ARRAY_BYTES = ARRAY_SIZE * sizeof(float);

   
    for(int i = 0; i < ARRAY_SIZE; i++)
    {
        h_input[i] = float(i);
    }

    float * d_input  = NULL;
    float * d_output = NULL;
    
    //allocate memory on GPU
    cudaMalloc( (void**) &d_input, ARRAY_BYTES);
    cudaMalloc( (void**) &d_output, ARRAY_BYTES);

    //transfer data to GPU
    cudaMemcpy(d_input, h_input, ARRAY_BYTES, cudaMemcpyHostToDevice);

    square<<<1, ARRAY_SIZE>>>(d_output, d_input);

    //transfer result from GPU to the application
    cudaMemcpy(h_output, d_output, ARRAY_BYTES, cudaMemcpyDeviceToHost);
    
    //print the result
    for(int i = 0; i < ARRAY_SIZE; i++)
    {
        printf("%f\n", h_output[i]);
    }

    cudaFree(d_input);
    cudaFree(d_output);
    
    cudaDeviceReset();

    return 0;
}