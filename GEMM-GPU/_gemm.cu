# include <iostream>
# define N 2

void printMatrix(int *a, int m, int n)
{
    for(int i = 0; i < m; i++)
    {
        for(int j = 0; j < n; j++)
        {
            printf(" %d ", a[i * n + j]);
        }
        printf("\n");
    }
    printf("\n");
}

void gemmCPU(int *a, int *b, int *c, int m, int n, int K)
{
    // m x k -> dimension of first matrix a
    // k x n -> dimension of second matrix b
    // m x n -> dimension of resulting matrix c

    // for each row in matrix a
    for(int i = 0; i < m; i++)
    {
        // for each column in matrix b
        for(int j = 0; j < n; j++)
        {
            // for each element in both row and column of matrix a, b
            for(int k = 0; k < K; k++)
            {
                // for each element i, j in matrix c, for each element k 
                // in row i * K of matrix a, we multiply with each element j
                // in each row k * N of matrix b. 
                // in other words one we iteratue thru each element in row of matrix 1
                // by offsetting each elemnt by k for each row i * k 
                // simultaneously we use row major order with k * n, to jump to
                // each row and get the j corresponding element of matrix b which would give us columns
                c[i * n + j] += a[i * K + k] * b[k * n + j];
            }
        }
    }
}

int main(void)
{
    int *a, *b, *c;

    size_t size = N * N * sizeof(int);

    a = (int*) malloc(size);
    b = (int*) malloc(size);
    c = (int*) malloc(size);

    for(int i = 0; i < N * N; i++)
    {
        a[i] = i;
        b[i] = i;
    }

    printMatrix(a, N, N);

    printMatrix(b, N, N);

    gemmCPU(a, b, c, N, N, N);

    printMatrix(c, N, N);
    free(a);
    free(b);
    free(c);
    return 0;
}