#include <iostream>

// define kernel

# define N 10

__global__ void add(int *a, int *b, int *c)
{
    int tid = blockIdx.x;

    if (tid < N)
    {
        c[tid] = a[tid] + b[tid];
    }
}

int main(void)
{
    int a[N], b[N], c[N];
    int *device_a, *device_b, *device_c;

    cudaMalloc( (void**)&device_a, N * sizeof(int) );
    cudaMalloc( (void**)&device_b, N * sizeof(int) );
    cudaMalloc( (void**)&device_c, N * sizeof(int) );
    for (int i = 0; i < N; i++)
    {
        a[i] = i;
        b[i] = i;
    }

    cudaMemcpy(device_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(device_b, b, N * sizeof(int), cudaMemcpyHostToDevice);
    add<<<10, 1>>>(device_a, device_b, device_c);

    cudaMemcpy(c, device_c, N * sizeof(int), cudaMemcpyDeviceToHost);

    cudaFree(device_a);
    cudaFree(device_b);
    cudaFree(device_c);

    int i = 0;
    while(i < N)
    {
        printf("%d + %d = %d\n", a[i], b[i], c[i]);
        i += 1;
    }
    return 0;
}