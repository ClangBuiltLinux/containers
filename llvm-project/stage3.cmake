# Please try to keep these cmake variables alphabetically sorted.

# Enable optimizations, as opposed to a debug build.
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")

# Explicitly use stage2's clang. Not necessary, just being explicit.
set(CMAKE_CXX_COMPILER "/usr/local/bin/clang++" CACHE FILEPATH "")
set(CMAKE_C_COMPILER "/usr/local/bin/clang" CACHE FILEPATH "")

# See above comment for CMAKE_CXX_COMPILER.
# Use the sysroot we've been building up.
set(CMAKE_CXX_FLAGS "--sysroot=/sysroot" CACHE STRING "")
set(CMAKE_C_FLAGS "--sysroot=/sysroot" CACHE STRING "")

# Statically link resulting executable.
set(CMAKE_EXE_LINKER_FLAGS "-static -lc++abi" CACHE STRING "")

# Use libc++ from stage2.
# TODO: is CMAKE_CXX_FLAGS still necessary if this is set?
set(LLVM_ENABLE_LIBCXX ON CACHE BOOL "")

# Use lld from stage2.
set(LLVM_ENABLE_LLD ON CACHE BOOL "")

# Just build clang and lld for now.
set(LLVM_ENABLE_PROJECTS "clang;lld" CACHE STRING "")

# FORCE_ON causes the build to fail if zlib is not found in the environment
# during configuration, rather than much later during link.
set(LLVM_ENABLE_ZLIB "FORCE_ON" CACHE STRING "")

# This is necessary to statically link libc++ into clang.
set(LLVM_STATIC_LINK_CXX_STDLIB "1" CACHE STRING "")

# Just build stage3 to target the host. It's not the end product, so it won't
# be able to target all of the kernel targets we can build.
set(LLVM_TARGETS_TO_BUILD "host;" CACHE STRING "")

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

# Disable static analyzer. Don't need it for stage3.
set(CLANG_ENABLE_STATIC_ANALYZER OFF CACHE BOOL "")

# Disable plugin support. Don't need it, ever.
set(CLANG_PLUGIN_SUPPORT OFF CACHE BOOL "")

# Because we're using --prefix=/sysroot/usr, zlib gets installed to a
# non-standard path.
set(ZLIB_INCLUDE_DIR "/sysroot/usr/include/zlib.h" CACHE FILEPATH "")
set(ZLIB_LIBRARY "/sysroot/usr/lib/libz.a" CACHE FILEPATH "")
