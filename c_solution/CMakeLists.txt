cmake_minimum_required(VERSION 3.31)
project(tokenizer C)

set(CMAKE_C_STANDARD 11)

add_executable(tokenizer source/main.c
        source/tokens.c
        source/tokens.h)
