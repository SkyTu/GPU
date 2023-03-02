BUILD_DIR = build

matmul: $(BUILD_DIR) $(BUILD_DIR)/main.o $(BUILD_DIR)/matrix_mul.o
	g++ -o matmul $(BUILD_DIR)/main.o $(BUILD_DIR)/matrix_mul.o -lcudart -L/usr/local/cuda/lib64
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)
$(BUILD_DIR)/main.o: main.cpp
	g++ -c main.cpp -o $(BUILD_DIR)/main.o
$(BUILD_DIR)/matrix_mul.o: matrix_mul.cu
	nvcc -c matrix_mul.cu -o $(BUILD_DIR)/matrix_mul.o

clean:
	-rm -f */*.o *.o */*.d *.d *.x core.* *.a gmon.out */*/*.o static/*.x *.so