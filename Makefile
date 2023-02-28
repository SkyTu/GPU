CUDA_VERSION=11.4
CUTLASS_PATH=ext/cutlass

CXX=/usr/local/cuda-$(CUDA_VERSION)/bin/nvcc
FLAGS := -Xcompiler="-O3,-w,-std=c++14,-pthread,-msse4.1,-maes,-msse2,-mpclmul,-fpermissive,-fpic,-pthread" -Xcudafe "--diag_suppress=declared_but_not_referenced"
DEBUG_FLAGS := -Xcompiler="-O0,-g,-w,-std=c++14,-pthread,-msse4.1,-maes,-msse2,-mpclmul,-fpermissive,-fpic,-pthread" -Xcudafe "--diag_suppress=declared_but_not_referenced"

LIBS := -lcrypto -lssl -lcudart -lcuda -lgtest -lcublas
OBJ_INCLUDES := -I '/usr/local/cuda-$(CUDA_VERSION)/include' -I '$(CUTLASS_PATH)/include' -I '$(CUTLASS_PATH)/tools/util/include' -I 'include'
INCLUDES := $(OBJ_INCLUDES), -L./ -L/usr/local/cuda-$(CUDA_VERSION)/lib64 -L$(CUTLASS_PATH)/build/tools/library


all: matmul

matmul: matrix_mul.o
	g++ test.cpp -o matmul -L/usr/local/cuda/lib64 -lcuda -lcudart matrix_mul.o

matrix_mul.o:
	nvcc -c -arch=compute_35 -code=sm_60 matrix_mul.cu

