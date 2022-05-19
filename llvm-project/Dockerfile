FROM alpine:edge AS source
RUN wget --no-clobber \
  https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.1/llvm-project-14.0.1.src.tar.xz

# Stage one
FROM alpine:edge AS stage_one

# Install the stage zero compiler; the prebuilt clang from alpine.
# _Unwind_Resume issues with llvm-libunwind? Cmake can't find it either?
# TODO: can we build stage1 with llvm binutils? llvm13 alpine package contains.
#RUN apk add --no-cache clang lld compiler-rt musl-dev
RUN apk add --no-cache clang lld musl-dev

COPY --from=source llvm-project-14.0.1.src.tar.xz /
RUN tar xf llvm-project-14.0.1.src.tar.xz && \
  mv llvm-project-14.0.1.src llvm-project

# libcxxabi depends on zlib-dev!
# compiler-rt depends on libexecinfo-dev! (unless gwp-asan is disabled)
# TODO: libxml2?
# llvm cmake throws lots of warnings without git
RUN apk add --no-cache cmake ninja python3 zlib-dev git

# This seems like a mistake that clang++ in alpine cannot compile C++ hello
# world; the libstdc++ headers are distributed with g++ in Alpine rather than
# the libstdc++ package. So we need to install g++ on Alpine to get the
# libstdc++ headers, but this will also pull in many dependencies like gcc and
# GNU binutils. We'll need GNU binutils for now (TODO: do we?) but let's remove
# the binaries installed by g++ and gcc while keeping the headers to ensure
# additional level of hermiticity.
RUN apk add --no-cache g++ && \
  apk info -L g++ gcc| grep "^usr/bin" | xargs rm && \
  ln -sf /usr/bin/clang /usr/bin/cc

# Test stage 0 clang and clang++.
COPY hello.c hello.cpp /
RUN clang hello.c && ./a.out && \
  clang++ hello.cpp && ./a.out

COPY stage1.cmake llvm-project/.
RUN cmake \
  -B llvm-project/llvm/build \
  -C llvm-project/stage1.cmake \
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

COPY --from=source llvm-project-14.0.1.src.tar.xz /
RUN tar xf llvm-project-14.0.1.src.tar.xz && \
  mv llvm-project-14.0.1.src llvm-project && \
  mkdir llvm-project/llvm/build

RUN apk add --no-cache cmake ninja python3 zlib-dev git zlib-static

# Cmake will prioritize .so over .a. :(
RUN rm /lib/libz.so

COPY stage2.cmake llvm-project/.
RUN cmake \
  -B llvm-project/llvm/build \
  -C llvm-project/stage2.cmake \
  -S llvm-project/llvm \
  -G Ninja

# TODO: build the rest of llvm binutils.
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
  # TODO: is this because we didn't set LIBCXX_CXX_ABI=libcxxabi ? \
  clang++ hello.cpp -static -lc++abi && ./a.out

# TODO: I think we want to use CMAKE_INSTALL_LIBDIR, CMAKE_INSTALL_PREFIX, and
# DESTDIR to start building up the sysroot...then we could avoid this
# symlinking nonsense at the start of other builds.
