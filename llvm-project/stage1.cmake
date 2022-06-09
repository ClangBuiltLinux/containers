# Please try to keep these cmake variables alphabetically sorted.

# Enable optimizations, as opposed to a debug build.
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")

# Use Alpine's clang and clang++ from their clang package as the stage0
# compilers.
set(CMAKE_CXX_COMPILER "/usr/bin/clang++" CACHE FILEPATH "")
set(CMAKE_C_COMPILER "/usr/bin/clang" CACHE FILEPATH "")

# Use Alpine's lld as the stage0 linker to link everything.
set(LLVM_ENABLE_LLD ON CACHE BOOL "")

# For stage 1, just build clang and LLD, which are used by the "runtimes build"
# to build the runtime libraries of LLVM.
set(LLVM_ENABLE_PROJECTS "clang;lld;" CACHE STRING "")

# LLVM "runtimes" build.
set(LLVM_ENABLE_RUNTIMES "compiler-rt;libcxx;libcxxabi;libunwind;" CACHE STRING "")

# FORCE_ON causes the build to fail if zlib is not found in the environment
# during configuration, rather than much later during link.
set(LLVM_ENABLE_ZLIB "FORCE_ON" CACHE STRING "")

# Just build stage1 to target the host. It's not the end product, so it won't
# be able to target all of the kernel targets we can build.
set(LLVM_TARGETS_TO_BUILD "host;" CACHE STRING "")

# Set clang's default -fuse-ld= to lld.
set(CLANG_DEFAULT_LINKER "lld" CACHE STRING "")

# Set clang's default --rtlib= to compiler-rt.
set(CLANG_DEFAULT_RTLIB "compiler-rt" CACHE STRING "")

# Disable arc migrate. We don't use that, ever.
set(CLANG_ENABLE_ARCMT OFF CACHE BOOL "")

# Disable static analyzer. Don't need it for stage1.
set(CLANG_ENABLE_STATIC_ANALYZER OFF CACHE BOOL "")

# Disable plugin support. Don't need it, ever.
set(CLANG_PLUGIN_SUPPORT OFF CACHE BOOL "")

# The compiler builtins are necessary.
set(COMPILER_RT_BUILD_BUILTINS ON CACHE BOOL "")

# GWP ASAN fails to build without libexecinfo-dev. Don't need it for stage1.
set(COMPILER_RT_BUILD_GWP_ASAN OFF CACHE BOOL "")

# Don't need libfuzzer, ever.
set(COMPILER_RT_BUILD_LIBFUZZER OFF CACHE BOOL "")

# Don't need memprof, ever.
set(COMPILER_RT_BUILD_MEMPROF OFF CACHE BOOL "")

# Don't need ORC, ever.
set(COMPILER_RT_BUILD_ORC OFF CACHE BOOL "")

# Disable profiling support. Not necessary for stage1.
set(COMPILER_RT_BUILD_PROFILE OFF CACHE BOOL "")

# Disable sanitizer support. Not necessary for stage1.
set(COMPILER_RT_BUILD_SANITIZERS OFF CACHE BOOL "")

# Don't need xray.
set(COMPILER_RT_BUILD_XRAY OFF CACHE BOOL "")

# Compiler-rt is meant as a replacement to libgcc.
set(COMPILER_RT_HAS_GCC_S_LIB OFF CACHE BOOL "")

# Who needs docs anyways? Can't RTFM if there is no FM.
set(LIBUNWIND_INCLUDE_DOCS OFF CACHE BOOL "")

# We don't plan to run the tests, disable them.
set(LIBUNWIND_INCLUDE_TESTS OFF CACHE BOOL "")

# We need the headers available when we install-libunwind.
set(LIBUNWIND_INSTALL_HEADERS ON CACHE BOOL "")

# Libunwind should use compiler-rt rather than libgcc.
set(LIBUNWIND_USE_COMPILER_RT ON CACHE BOOL "")

# This is needed to break the cycle between libc, libc++, and libunwind.
set(LIBCXXABI_ENABLE_STATIC_UNWINDER ON CACHE BOOL "")

# We don't plan to run the tests; don't build them.
set(LIBCXXABI_INCLUDE_TESTS OFF CACHE BOOL "")

# We want libc++abi to use compiler-rt.
set(LIBCXXABI_USE_COMPILER_RT ON CACHE BOOL "")

# We want libc++abi to use LLVM's libunwind.
set(LIBCXXABI_USE_LLVM_UNWINDER ON CACHE BOOL "")

# We want libc++ to use libc++abi.
set(LIBCXX_CXX_ABI libcxxabi CACHE BOOL "")

# We don't need C++ experimental APIs.
set(LIBCXX_ENABLE_EXPERIMENTAL_LIBRARY OFF CACHE BOOL "")

# We want libc++ to use compiler-rt. If we don't disable libatomic explicitly,
# libc++ will try to link against it.
set(LIBCXX_HAS_ATOMIC_LIB OFF CACHE BOOL "")
set(LIBCXX_HAS_GCC_LIB OFF CACHE BOOL "")
set(LIBCXX_HAS_GCC_S_LIB OFF CACHE BOOL "")

# The C++ standard library requires the C library. libc++ assumes that the
# default C library is glibc due to the prevalence, however, as we are using
# musl, we need to indicate that we are using musl to prevent failures due to
# incorrect assumptions, particularly about locales.
set(LIBCXX_HAS_MUSL_LIBC ON CACHE BOOL "")

# We don't plan to run the benchmarks, so don't build them.
set(LIBCXX_INCLUDE_BENCHMARKS OFF CACHE BOOL "")

# Don't build docs.
set(LIBCXX_INCLUDE_DOCS OFF CACHE BOOL "")

# Don't build tests.
set(LIBCXX_INCLUDE_TESTS OFF CACHE BOOL "")

# We want libc++ to use compiler-rt.
set(LIBCXX_USE_COMPILER_RT ON CACHE BOOL "")
