#include "matrix_mul.cuh"
#include <vector>
#define A_COL 6
#define SHARE 6
#define B_ROW 6

int main(){
    std::vector<uint64_t>a(A_COL * SHARE, 1);
    std::vector<uint64_t>b(SHARE * B_ROW, 75);
    std::vector<uint64_t>c(A_COL * B_ROW, 0);
    matrixMultiplicationWrapper(a, b, c, false, false, A_COL, SHARE, SHARE, B_ROW);
}