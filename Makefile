matmul: main.o matrix_mul.o
	g++ -o matmul main.o matrix_mul.o -lcudart -L/usr/local/cuda/lib64
main.o: main.cpp
	g++ -c main.cpp
matrix_mul.o: matrix_mul.cu
	nvcc -c matrix_mul.cu

clean:
	-rm -f */*.o *.o */*.d *.d *.x core.* *.a gmon.out */*/*.o static/*.x *.so