#include <stdio.h>
#include <iostream>
#include "foo.cuh" //注意包含头文件
 

int main()
{
    std::cout<<"Hello C++"<<std::endl;
    helloworldwrapper(); // 这个函数是kernel函数的wrapper函数
    return 0;
}