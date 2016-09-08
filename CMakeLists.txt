cmake_minimum_required(VERSION 2.8)
project(SlidingDFT_Test CXX)

include_directories(.)
add_executable(SlidingDFT_Test sliding_dft.hpp testbench/main.cpp testbench/test1_data.h)

# ensure C++11
include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
if(COMPILER_SUPPORTS_CXX11)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
endif()

# on modern CMake, do this to ensure C++11
set_property(TARGET SlidingDFT_Test PROPERTY CXX_STANDARD 11)
set_property(TARGET SlidingDFT_Test PROPERTY CXX_STANDARD_REQUIRED ON)
