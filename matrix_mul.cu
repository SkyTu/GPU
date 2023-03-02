#include "matrix_mul.h"
#include <sys/time.h>
#include <fstream>
#include <iostream>
#include <cuda_runtime.h>
#include <math.h>
#include <thrust/device_vector.h>
#include <thrust/functional.h>
#include <thrust/sequence.h>
#include <thrust/fill.h>
#include <thrust/transform.h>
#define MAX_THREADS_PER_BLOCK 32
namespace kernel{
template<typename T>
__global__ void matrixMultiplication(const T *a, const T *b, T *c,
        bool transpose_a, bool transpose_b, int a_rows, int a_cols, int b_rows, int b_cols) {

    int ROW = blockIdx.y*blockDim.y+threadIdx.y;
    printf("ROW: %d blockIdx.y: %d blockDim.y %d threadIdx.y: %d\n", ROW, blockIdx.y, blockDim.y, threadIdx.y);
    int COL = blockIdx.x*blockDim.x+threadIdx.x;
    printf("COL: %d blockIdx.x: %d blockDim.x %d threadIdx.x: %d\n", ROW, blockIdx.x, blockDim.x, threadIdx.y);

    int c_rows = transpose_a ? a_cols : a_rows;
    int shared = transpose_a ? a_rows : a_cols;
    int c_cols = transpose_b ? b_rows : b_cols;

    if (ROW < c_rows && COL < c_cols) {
        for (int k = 0; k < shared; k++) {

            int a_idx = transpose_a ? k * a_cols + ROW : ROW * a_cols + k;
            int b_idx = transpose_b ? COL * b_cols + k : k * b_cols + COL;                
            c[ROW*c_cols + COL] += a[a_idx] * b[b_idx];
        }
    }
}
}

namespace gpu {
template<typename T, typename I>
void matrixMultiplication(
        const thrust::device_vector<T, I> *a, const thrust::device_vector<T, I> *b, thrust::device_vector<T, I> *c,
        bool transpose_a, bool transpose_b,
        size_t a_rows, size_t a_cols, size_t b_rows, size_t b_cols) {

    size_t rows = transpose_a ? a_cols : a_rows;

    size_t shared = transpose_a ? a_rows : a_cols;
    assert(shared == (transpose_b ? b_cols : b_rows));

    size_t cols = transpose_b ? b_rows : b_cols;

    printf("matmul: %dx%dx%d\n", rows, shared, cols);

    dim3 threadsPerBlock(cols, rows);
    dim3 blocksPerGrid(1, 1);

    if (cols > MAX_THREADS_PER_BLOCK) {
        threadsPerBlock.x = MAX_THREADS_PER_BLOCK;
        blocksPerGrid.x = ceil(double(cols)/double(threadsPerBlock.x));
    }
    
    if (rows > MAX_THREADS_PER_BLOCK) {
        threadsPerBlock.y = MAX_THREADS_PER_BLOCK;
        blocksPerGrid.y = ceil(double(rows)/double(threadsPerBlock.y));
    }

    kernel::matrixMultiplication<<<blocksPerGrid,threadsPerBlock>>>(
        thrust::raw_pointer_cast(&a->begin()[0]),
        thrust::raw_pointer_cast(&b->begin()[0]),
        thrust::raw_pointer_cast(&c->begin()[0]),
        transpose_a, transpose_b, a_rows, a_cols, b_rows, b_cols
    );

    cudaThreadSynchronize();
}
}


template<typename T>
void matrixMultiplication(
    std::vector<T> a, std::vector<T> b, std::vector<T> c,
    bool transpose_a, bool transpose_b,
    size_t a_rows, size_t a_cols, size_t b_rows, size_t b_cols){
        thrust::device_vector<T> gpu_a(a.begin(), a.end());
        thrust::device_vector<T> gpu_b(b.begin(), b.end());
        thrust::device_vector<T> gpu_c(c.begin(), c.end());

        gpu::matrixMultiplication(
            &gpu_a, &gpu_b, &gpu_c,
            transpose_a, transpose_b, a_rows, a_cols, b_rows, b_cols
        );
    }

template void matrixMultiplicationWrapper(std::vector<uint64_t> a, std::vector<uint64_t> b, std::vector<uint64_t> c, bool transpose_a, 
    bool transpose_b, size_t a_rows, size_t a_cols, size_t b_rows, size_t b_cols);

template void matrixMultiplicationWrapper(std::vector<uint32_t> a, std::vector<uint32_t> b, std::vector<uint32_t> c, bool transpose_a, 
    bool transpose_b, size_t a_rows, size_t a_cols, size_t b_rows, size_t b_cols);

template void matrixMultiplicationWrapper(std::vector<uint16_t> a, std::vector<uint16_t> b, std::vector<uint16_t> c, bool transpose_a, 
    bool transpose_b, size_t a_rows, size_t a_cols, size_t b_rows, size_t b_cols);

template void matrixMultiplicationWrapper(std::vector<uint8_t> a, std::vector<uint8_t> b, std::vector<uint8_t> c, bool transpose_a, 
    bool transpose_b, size_t a_rows, size_t a_cols, size_t b_rows, size_t b_cols);

template void matrixMultiplicationWrapper(std::vector<int> a, std::vector<int> b, std::vector<int> c, bool transpose_a, 
    bool transpose_b, size_t a_rows, size_t a_cols, size_t b_rows, size_t b_cols);

template void matrixMultiplicationWrapper(std::vector<float> a, std::vector<float> b, std::vector<float> c, bool transpose_a, 
    bool transpose_b, size_t a_rows, size_t a_cols, size_t b_rows, size_t b_cols);


