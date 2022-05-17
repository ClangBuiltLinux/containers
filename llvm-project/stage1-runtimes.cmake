set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
set(CMAKE_CXX_COMPILER "/usr/bin/clang++" CACHE STRING "")
set(CMAKE_C_COMPILER "/usr/bin/clang" CACHE STRING "")
set(CMAKE_EXE_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(CMAKE_SHARED_LINKER_FLAGS "-fuse-ld=lld" CACHE STRING "")
set(LLVM_DEFAULT_TARGET_TRIPLE "x86_64-alpine-linux-musl" CACHE STRING "")
set(LLVM_ENABLE_LLD ON CACHE BOOL "")
set(LLVM_ENABLE_PROJECTS "clang;lld;" CACHE STRING "")
set(LLVM_ENABLE_RUNTIMES "compiler-rt;libcxx;libcxxabi;libunwind;" CACHE STRING "")
set(LLVM_ENABLE_ZLIB "FORCE_ON" CACHE STRING "")
set(LLVM_TARGETS_TO_BUILD "X86;" CACHE STRING "")
set(CLANG_DEFAULT_LINKER "lld" CACHE STRING "")
# TODO: it seems this was ignored by the runtimes build...
set(CLANG_DEFAULT_RTLIB "compiler-rt" CACHE STRING "")
set(CLANG_ENABLE_ARCMT OFF CACHE BOOL "")
set(CLANG_ENABLE_STATIC_ANALYZER OFF CACHE BOOL "")
set(CLANG_PLUGIN_SUPPORT OFF CACHE BOOL "")
set(COMPILER_RT_BUILD_BUILTINS ON CACHE BOOL "")
set(COMPILER_RT_BUILD_GWP_ASAN OFF CACHE BOOL "")
set(COMPILER_RT_BUILD_LIBFUZZER OFF CACHE BOOL "")
set(COMPILER_RT_BUILD_MEMPROF OFF CACHE BOOL "")
set(COMPILER_RT_BUILD_ORC OFF CACHE BOOL "")
set(COMPILER_RT_BUILD_PROFILE OFF CACHE BOOL "")
set(COMPILER_RT_BUILD_SANITIZERS OFF CACHE BOOL "")
set(COMPILER_RT_BUILD_XRAY OFF CACHE BOOL "")
set(COMPILER_RT_HAS_GCC_S_LIB OFF CACHE BOOL "")
set(LIBUNWIND_INCLUDE_DOCS OFF CACHE BOOL "")
set(LIBUNWIND_INCLUDE_TESTS OFF CACHE BOOL "")
set(LIBUNWIND_INSTALL_HEADERS ON CACHE BOOL "")
set(LIBUNWIND_USE_COMPILER_RT ON CACHE BOOL "")
set(LIBCXXABI_ENABLE_STATIC_UNWINDER ON CACHE BOOL "")
set(LIBCXXABI_INCLUDE_TESTS OFF CACHE BOOL "")
set(LIBCXXABI_USE_COMPILER_RT ON CACHE BOOL "")
set(LIBCXXABI_USE_LLVM_UNWINDER ON CACHE BOOL "")
set(LIBCXX_CXX_ABI libcxxabi CACHE BOOL "")
set(LIBCXX_ENABLE_EXPERIMENTAL_LIBRARY OFF CACHE BOOL "")
set(LIBCXX_HAS_ATOMIC_LIB OFF CACHE BOOL "")
set(LIBCXX_HAS_GCC_LIB OFF CACHE BOOL "")
set(LIBCXX_HAS_GCC_S_LIB OFF CACHE BOOL "")
set(LIBCXX_HAS_MUSL_LIBC ON CACHE BOOL "")
set(LIBCXX_INCLUDE_BENCHMARKS OFF CACHE BOOL "")
set(LIBCXX_INCLUDE_DOCS OFF CACHE BOOL "")
set(LIBCXX_INCLUDE_TESTS OFF CACHE BOOL "")
set(LIBCXX_USE_COMPILER_RT ON CACHE BOOL "")
