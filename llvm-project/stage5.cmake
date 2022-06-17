# Please try to keep these cmake variables alphabetically sorted.

# Enable optimizations, as opposed to a debug build.
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")

# Explicitly use stage3's clang. Not necessary, just being explicit.
set(CMAKE_CXX_COMPILER "/usr/local/bin/clang++" CACHE FILEPATH "")
set(CMAKE_C_COMPILER "/usr/local/bin/clang" CACHE FILEPATH "")

# See above comment for CMAKE_CXX_COMPILER.
# Use the sysroot we've been building up.
set(CMAKE_CXX_FLAGS "--sysroot=/sysroot" CACHE STRING "")
set(CMAKE_C_FLAGS "--sysroot=/sysroot" CACHE STRING "")

# Statically link resulting executable.
set(CMAKE_EXE_LINKER_FLAGS "-static -lc++abi" CACHE STRING "")

# The compiler builtins are necessary.
set(COMPILER_RT_BUILD_BUILTINS ON CACHE BOOL "")

# GWP ASAN fails to build without libexecinfo-dev. Don't need it for stage5.
set(COMPILER_RT_BUILD_GWP_ASAN OFF CACHE BOOL "")

# Don't need libfuzzer, ever.
set(COMPILER_RT_BUILD_LIBFUZZER OFF CACHE BOOL "")

# Don't need memprof, ever.
set(COMPILER_RT_BUILD_MEMPROF OFF CACHE BOOL "")

# Don't need ORC, ever.
set(COMPILER_RT_BUILD_ORC OFF CACHE BOOL "")

# Explicitly enable profiling support. The implicit default is ON.
set(COMPILER_RT_BUILD_PROFILE ON CACHE BOOL "")

# Disable sanitizer support. Not necessary for stage5.
set(COMPILER_RT_BUILD_SANITIZERS OFF CACHE BOOL "")

# Don't need xray.
set(COMPILER_RT_BUILD_XRAY OFF CACHE BOOL "")

# Use libc++ from stage3.
# TODO: is CMAKE_CXX_FLAGS still necessary if this is set?
set(LLVM_ENABLE_LIBCXX ON CACHE BOOL "")

# Use lld from stage3.
set(LLVM_ENABLE_LLD ON CACHE BOOL "")

# TODO: clang segfaults when building llvm-tblgen. Do we need to use
# `--ulimit nofile=65536` for `docker build`?
# Build LLVM with thinLTO. This requires we bump the default memory limit up.
#set(LLVM_ENABLE_LTO "Thin" CACHE STRING "")

# Build clang, lld, and compiler-rt.
set(LLVM_ENABLE_PROJECTS "clang;lld;compiler-rt" CACHE STRING "")

# FORCE_ON causes the build to fail if zlib is not found in the environment
# during configuration, rather than much later during link.
set(LLVM_ENABLE_ZLIB "FORCE_ON" CACHE STRING "")

# Consume PGO training data from stage4.
set(LLVM_PROFDATA_FILE "profdata.prof" CACHE FILEPATH "")

# This is necessary to statically link libc++ into clang.
set(LLVM_STATIC_LINK_CXX_STDLIB "1" CACHE STRING "")

# Build all relevant targets.
set(LLVM_TARGETS_TO_BUILD "AArch64;ARM;Hexagon;Mips;PowerPC;RISCV;SystemZ;X86" CACHE STRING "")

# Set clang's default --stdlib= to libc++.
set(CLANG_DEFAULT_CXX_STDLIB "libc++" CACHE STRING "")

# Set clang's default -fuse-ld= to lld.
set(CLANG_DEFAULT_LINKER "lld" CACHE STRING "")

# Have clang default to llvm-objcopy.
set(CLANG_DEFAULT_OBJCOPY "llvm-objcopy" CACHE STRING "")

# Set clang's default --rtlib= to compiler-rt.
set(CLANG_DEFAULT_RTLIB "compiler-rt" CACHE STRING "")

# Set clang's default --unwindlib= to libunwind.
set(CLANG_DEFAULT_UNWINDLIB "libunwind" CACHE STRING "")

# Disable arc migrate. We don't use that, ever.
set(CLANG_ENABLE_ARCMT OFF CACHE BOOL "")

# Disable static analyzer. Don't need it for stage5.
set(CLANG_ENABLE_STATIC_ANALYZER OFF CACHE BOOL "")

# Disable plugin support. Don't need it, ever.
set(CLANG_PLUGIN_SUPPORT OFF CACHE BOOL "")

# Because we're using --prefix=/sysroot/usr, zlib gets installed to a
# non-standard path.
set(ZLIB_INCLUDE_DIR "/sysroot/usr/include/zlib.h" CACHE FILEPATH "")
set(ZLIB_LIBRARY "/sysroot/usr/lib/libz.a" CACHE FILEPATH "")
