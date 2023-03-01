#include <vector>
// GPU configuration
#include <stdint.h>


template<typename T>
void matrixMultiplicationWrapper(std::vector<T> a, std::vector<T> b, std::vector<T> c, bool transpose_a, 
    bool transpose_b, size_t a_rows, size_t a_cols, size_t b_rows, size_t b_cols);


void matrixMultiplicationWrapper(std::vector<uint64_t> a, std::vector<uint64_t> b, std::vector<uint64_t> c, bool transpose_a, 
    bool transpose_b, size_t a_rows, size_t a_cols, size_t b_rows, size_t b_cols);
