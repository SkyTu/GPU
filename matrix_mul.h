#include <vector>
// GPU configuration
#include <stdint.h>


template<typename T> 
void matrixMultiplication(
    std::vector<T> a, std::vector<T> b, std::vector<T> c, bool transpose_a, bool transpose_b,
    size_t a_rows, size_t a_cols, size_t b_rows, size_t b_cols);


template<typename T>
void matrixMultiplicationWrapper(std::vector<T> a, std::vector<T> b, std::vector<T> c, bool transpose_a, 
    bool transpose_b, size_t a_rows, size_t a_cols, size_t b_rows, size_t b_cols){
    matrixMultiplication(a, b, c, transpose_a, transpose_b, a_rows, a_cols, b_rows, b_cols);
}