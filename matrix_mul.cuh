#include <vector>
// GPU configuration
#define MAX_THREADS_PER_BLOCK 32

extern "C"{
#ifdef __cplusplus
#define __STDC_CONSTANT_MACROS
#ifdef _STDINT_H
#undef _STDINT_H
#endif
# include <stdint.h>
#endif
}
template<typename T>
void matrixMultiplicationWrapper(std::vector<T> a, std::vector<T> b, std::vector<T> c, bool transpose_a, bool transpose_b, size_t a_rows, size_t a_cols, size_t b_rows, size_t b_cols);