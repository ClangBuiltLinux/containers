# Please try to keep these cmake variables alphabetically sorted.

# Enable optimizations, as opposed to a debug build.
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")

# Use stage1's clang to bootstrap stage2, as opposed to Alpine's clang (which
# shouldn't be installed on the system at this point, but would be installed to
# /usr/bin/clang).
set(CMAKE_CXX_COMPILER "/usr/local/bin/clang++" CACHE FILEPATH "")

# Use libc++ from stage1.
# We could not set CLANG_DEFAULT_CXX_STDLIB in stage1 because Alpine doesn't
# distribute libc++ ATM.
# Even though we later will set LLVM_ENABLE_LIBCXX, cmake will fail thinking
# that "The C++ compiler is not able to compile a simple test program." As with
# stage1, this is an unfortunate effect of Alpine packaging the stdlibc++
# headers in the g++ package, rather than the libstdc++ package. In stage1, we
# used those headers; in stage2 we do not.
set(CMAKE_CXX_FLAGS "--stdlib=libc++" CACHE STRING "")

# See above comment for CMAKE_CXX_COMPILER.
set(CMAKE_C_COMPILER "/usr/local/bin/clang" CACHE FILEPATH "")

# Use libunwind from stage1.
# Statically link resulting executable.
set(CMAKE_EXE_LINKER_FLAGS "--unwindlib=libunwind -static -lc++abi" CACHE STRING "")
set(CMAKE_SHARED_LINKER_FLAGS "--unwindlib=libunwind" CACHE STRING "")

# Use libc++ from stage1.
# TODO: is CMAKE_CXX_FLAGS still necessary if this is set?
set(LLVM_ENABLE_LIBCXX ON CACHE BOOL "")

# Use lld from stage1.
set(LLVM_ENABLE_LLD ON CACHE BOOL "")

# Just build clang and lld for now.
set(LLVM_ENABLE_PROJECTS "clang;lld" CACHE STRING "")

# FORCE_ON causes the build to fail if zlib is not found in the environment
# during configuration, rather than much later during link.
set(LLVM_ENABLE_ZLIB "FORCE_ON" CACHE STRING "")

# This is necessary to statically link libc++ into clang.
set(LLVM_STATIC_LINK_CXX_STDLIB "1" CACHE STRING "")

# Just build stage2 to target the host. It's not the end product, so it won't
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

# Disable static analyzer. Don't need it for stage2.
set(CLANG_ENABLE_STATIC_ANALYZER OFF CACHE BOOL "")

# Disable plugin support. Don't need it, ever.
set(CLANG_PLUGIN_SUPPORT OFF CACHE BOOL "")
