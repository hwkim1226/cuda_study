#include <iostream>
#include <stdio.h>
#include <fstream>
#include <cmath>

#include "cuda_runtime.h"
#include "device_launch_parameters.h"

using namespace std;

void __global__ sampleAdd(int *src, int* dst);


int main()
{
    int *h_arr;
    int *d_arr;
    int *d_add;
    int *h_add;

    cudaMallocHost((void**)&h_arr, 128*sizeof(int));
    cudaMalloc((void**)&d_arr, 128*sizeof(int));
    cudaMalloc((void**)&d_add, 128*sizeof(int));
    cudaMallocHost((void**)&h_add, 128*sizeof(int));


    for (int i = 0; i < 128; i++)
    {
        h_arr[i] = rand() % 128;
    }

    dim3 blocks(128, 1, 1);
    dim3 grids(1, 1, 1);
    cudaMemcpy(d_arr, h_arr, 128*sizeof(int), cudaMemcpyHostToDevice);
    sampleAdd<<<grids, blocks>>>(d_arr, d_add);
    cudaMemcpy(h_add, d_add, 128*sizeof(int), cudaMemcpyDeviceToHost);
    
    for (int i = 0; i < 128; i++)
    {
        cout << i << "th input is " << h_arr[i] << ", and output is " << h_add[i] << endl;
    }

    
    return 0;
}


void __global__ sampleAdd(int *src, int* dst)
{
    int a = threadIdx.x;
    dst[a] += src[a] + a;
}