cmake_minimum_required(VERSION 3.31)
project(pokkenizer C)

set(CMAKE_C_STANDARD 11)

add_executable(pokkenizer source/main.c
        source/tokens.c
        source/tokens.h)
