# Use Alpine's clang and clang++ from their clang package as the stage0
# compilers.
set(CMAKE_CXX_COMPILER "/usr/bin/clang++" CACHE FILEPATH "")
set(CMAKE_C_COMPILER "/usr/bin/clang" CACHE FILEPATH "")
set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "")

# Use Alpine's lld as the stage0 linker to link everything.
set(LLVM_ENABLE_LLD ON CACHE BOOL "")

# TODO: why does clang need to be enabled?
set(LLVM_ENABLE_PROJECTS "clang;compiler-rt;libc;" CACHE STRING "")

set(LLVM_LIBC_FULL_BUILD ON CACHE BOOL "")
set(LLVM_LIBC_INCLUDE_SCUDO ON CACHE BOOL "")
set(COMPILER_RT_BUILD_SCUDO_STANDALONE_WITH_LLVM_LIBC ON CACHE BOOL "")
set(COMPILER_RT_BUILD_GWP_ASAN OFF CACHE BOOL "")
set(COMPILER_RT_SCUDO_STANDALONE_BUILD_SHARED OFF CACHE BOOL "")
