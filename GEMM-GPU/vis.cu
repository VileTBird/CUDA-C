#include <stdio.h>
#include <stdlib.h>

void gemmCPU(int *a, int *b, int *c, int m, int k, int n)
{
    for (int i = 0; i < m; i++)         // rows of A
    {
        for (int j = 0; j < n; j++)     // columns of B
        {
            c[i * n + j] = 0;           // initialize result cell
            for (int x = 0; x < k; x++) // shared dim: cols of A, rows of B
            {
                c[i * n + j] += a[i * k + x] * b[x * n + j];
            }
        }
    }
}

void printMatrixWithLabel(const char* label, int *a, int cols, int rows)
{
    printf("%s (%dx%d):\n", label, rows, cols);
    for (int i = 0; i < rows; i++)
    {
        for (int j = 0; j < cols; j++)
        {
            printf("%4d ", a[i * cols + j]);
        }
        printf("\n");
    }
    printf("\n");
}

int main(void)
{
    int m = 2, k = 3, n = 2;

    // Matrix A (2x3)
    int A[] = {
        1, 2, 3,
        4, 5, 6
    };

    // Matrix B (3x2)
    int B[] = {
        1, 4,
        3, 6,
        5, 8
    };

    // Output matrix C (2x2)
    int* C = (int*)malloc(m * n * sizeof(int));

    printMatrixWithLabel("Matrix A", A, k, m);  // A is m x k
    printMatrixWithLabel("Matrix B", B, n, k);  // B is k x n

    gemmCPU(A, B, C, m, k, n);

    printMatrixWithLabel("Result (A x B)", C, n, m);  // C is m x n

    free(C);
    return 0;
}
