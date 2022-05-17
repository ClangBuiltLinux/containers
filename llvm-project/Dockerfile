# Stage one
FROM alpine:edge AS stage_one

# Install the stage zero compiler; the prebuilt clang from alpine.
# _Unwind_Resume issues with llvm-libunwind? Cmake can't find it either?
# llvm13 for llvm binutils
#RUN apk add --no-cache clang lld compiler-rt musl-dev
RUN apk add --no-cache clang lld musl-dev

# TODO: fetch from github
COPY llvm-project-14.0.1.src.tar.xz /
RUN tar xf llvm-project-14.0.1.src.tar.xz && \
  mv llvm-project-14.0.1.src llvm-project && \
  mkdir llvm-project/llvm/build

# libcxxabi depends on zlib-dev!
# compiler-rt depends on libexecinfo-dev! (unless gwp-asan is disabled)
# TODO: libxml2?
# llvm cmake throws lots of warnings without git
RUN apk add --no-cache cmake ninja python3 zlib-dev git

# This seems like a mistake that clang++ in alpine cannot compile C++ hello
# world.
# TODO: this also pulls in gnu binutils...
RUN apk add --no-cache g++ && \
  find /usr/bin/ | grep -e gcc -e g++ | grep -v clang++ | xargs rm && \
  rm /usr/bin/cpp /usr/bin/c99 /usr/bin/c89 && \
  ln -sf /usr/bin/clang /usr/bin/cc

# Test stage 0 clang and clang++.
COPY hello.c hello.cpp /

RUN clang hello.c && ./a.out && \
  clang++ hello.cpp && ./a.out

COPY stage1-runtimes.cmake llvm-project/.
RUN cmake \
  -B llvm-project/llvm/build \
  -C llvm-project/stage1-runtimes.cmake \
  -S llvm-project/llvm \
  -G Ninja

# While these could be one single command, generally for development it's very
# painful when one of many specified targets fail as then nothing gets cached
# by docker. Break these into distinct commands to optimize for development
# iteration speed.
RUN ninja -C llvm-project/llvm/build install-builtins
RUN ninja -C llvm-project/llvm/build install-compiler-rt
RUN ninja -C llvm-project/llvm/build install-unwind
RUN ninja -C llvm-project/llvm/build install-cxxabi
# Necessary for libcxx
RUN apk add --no-cache linux-headers
RUN ninja -C llvm-project/llvm/build install-cxx
RUN ninja -C llvm-project/llvm/build install-clang install-lld
RUN ninja -C llvm-project/llvm/build install-clang-resource-headers

### END STAGE1
### START STAGE2

# STAGE2 goal, build WITHOUT apk add
FROM alpine:edge as stage_two
COPY --from=stage_one llvm-project/llvm/build/bin /usr/local/bin
COPY --from=stage_one /usr/local/lib /usr/local/lib
COPY --from=stage_one /usr/local/include /usr/local/include
COPY hello.c hello.cpp /

RUN cd /usr/lib/ && \
  for library in libc++abi.so.1 libc++.a libc++abi.a libc++.so.1 libunwind.so.1 libunwind.a; \
    do ln -s "/usr/local/lib/x86_64-alpine-linux-musl/${library}" . ; \
  done

# The stage 1 build of clang/lld/other binaries still depends on libstdc++.
RUN apk add --no-cache libstdc++ musl-dev

# Pause for a quick sanity check
# Stage 1 clang only defaulted-on compiler-rt and lld
RUN clang++ hello.cpp \
  --stdlib=libc++ \
  --rtlib=compiler-rt \
  --unwindlib=libunwind \
  -fuse-ld=lld && \
  ./a.out

RUN clang++ hello.cpp \
  --stdlib=libc++ \
  --unwindlib=libunwind && \
  ./a.out

RUN clang++ hello.cpp \
  --stdlib=libc++ \
  --unwindlib=libunwind \
  -static \
  -lc++abi && \
  ./a.out

COPY llvm-project-14.0.1.src.tar.xz /
RUN tar xf llvm-project-14.0.1.src.tar.xz && \
  mv llvm-project-14.0.1.src llvm-project && \
  mkdir llvm-project/llvm/build

RUN apk add --no-cache cmake ninja python3 zlib-dev git zlib-static

# Cmake will prioritize .so over .a. :(
RUN rm /lib/libz.so

RUN cd llvm-project/llvm/build && cmake \
  -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_CXX_COMPILER=/usr/local/bin/clang++ \
  -D CMAKE_C_COMPILER=/usr/local/bin/clang \
# Stage 1 clang only defaulted-on compiler-rt and lld \
  -D CMAKE_EXE_LINKER_FLAGS="--unwindlib=libunwind -static -lc++abi" \
  -D LLVM_STATIC_LINK_CXX_STDLIB=1 \
  -D LLVM_ENABLE_LIBCXX=ON \
  #-D LIBCXX_CXX_ABI=libcxxabi \
  -D CMAKE_SHARED_LINKER_FLAGS="--unwindlib=libunwind" \
  -D CMAKE_CXX_FLAGS="--stdlib=libc++" \
  -D LLVM_DEFAULT_TARGET_TRIPLE=x86_64-alpine-linux-musl \
  -D LLVM_ENABLE_LLD=ON \
  -D LLVM_ENABLE_PROJECTS="clang;lld" \
  -D LLVM_ENABLE_ZLIB=FORCE_ON \
  -D LLVM_TARGETS_TO_BUILD="X86;" \
  -D CLANG_DEFAULT_CXX_STDLIB=libc++ \
  -D CLANG_DEFAULT_LINKER=lld \
  -D CLANG_DEFAULT_OBJCOPY=llvm-objcopy \
  -D CLANG_DEFAULT_RTLIB=compiler-rt \
  -D CLANG_DEFAULT_UNWINDLIB=libunwind \
  -D CLANG_ENABLE_ARCMT=OFF \
  -D CLANG_ENABLE_STATIC_ANALYZER=OFF \
  -D CLANG_PLUGIN_SUPPORT=OFF \
  -G Ninja \
  ..

RUN ninja -C llvm-project/llvm/build install-clang install-lld
RUN ninja -C llvm-project/llvm/build install-clang-resource-headers

# Pause for a quick sanity check
# python3 and cmake both depend on libstdc++
RUN apk del libstdc++ cmake ninja python3 zlib-dev git zlib-static
#RUN apk del libatomic
# Stage 2 clang should have intended defaults
RUN clang hello.c && ./a.out && \
  clang hello.c -static && ./a.out && \
  clang++ hello.cpp && ./a.out && \
  clang++ hello.cpp -static -lc++abi && ./a.out
