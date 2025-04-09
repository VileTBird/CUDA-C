#include <iostream>

# define N 10000

__global__ void add(int *a, int *b, int *c)
{

    // so basically this formula makes it so that each id across each thread in each fucking block sequential and incremental
    // how? i have no fucking clue how it fucking works but it just does i even did it on pen & paper to figure out intuiton
    // god in each block if we have 4 threads itll repeat with 0, 1, 2, 3 for threadIdx.x
    // if we add the block number lets say we have 4 blocks, then it would be 0 + 0, 1+0... 0 + 1, 1 + 1, do u see how it can create overlap
    // here when we multiply it by the number of threads which is blockDim with our block id
    // then 0 + 0 * 4, 1+ 0 * 4... 3 + 0 * 4, 0 + 1 * 4, 1 + 1 * 4, do u see how it makes it incremental?
    // so yeah its cool but i dont get it just that it works ill just remember it for later
    int id = threadIdx.x + blockIdx.x * blockDim.x;

    if(id < N)
    {
        c[id] = a[id] + b[id];
    }
}

int main(void)
{
    int a[N], b[N], c[N];
    int *device_a, *device_b, *device_c;

    cudaMalloc((void**)&device_a, N * sizeof(int));
    cudaMalloc((void**)&device_b, N * sizeof(int));
    cudaMalloc((void**)&device_c, N * sizeof(int));

    for(int i = 0; i < N; i++)
    {
        a[i] = i;
        b[i] = -i;
    }

    cudaMemcpy(device_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(device_b, b, N * sizeof(int), cudaMemcpyHostToDevice);

    add<<<(N + 127)/128,128>>>(device_a, device_b, device_c);

    cudaMemcpy(c, device_c, N * sizeof(int), cudaMemcpyDeviceToHost);

    for(int i = 0; i < N; i++)
    {
        printf("%d + %d = %d\n", a[i], b[i], c[i]);
    }

    cudaFree(device_a);
    cudaFree(device_b);
    cudaFree(device_c);
    return 0;
}