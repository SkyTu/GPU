#include "foo.cuh"

__global__ void helloworld(){
    printf("Hello World from the gpu");
}

void helloworldwrapper(){
    helloworld<<<1,1>>>();
    cudaDeviceSynchronize();
}