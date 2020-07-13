cmake_minimum_required(VERSION 3.0)

project(yaco)

enable_language(ASM)

set(CMAKE_C_FLAGS "-Wall -Wextra -O3")
set(CMAKE_C_FLAGS_DEBUG "-Wall -Wextra -Wpedantic -Werror -Og -g")

include_directories(include)
add_library(yaco SHARED lib/yaco.c lib/yaco-asm.s)
add_library(yaco_static STATIC lib/yaco.c lib/yaco-asm.s)
