FROM alpine:edge

# TODO: change to container registry
COPY --from=clangbuiltlinux/llvm-project:latest llvm-project/llvm/build/bin /usr/local/bin
COPY --from=clangbuiltlinux/llvm-project:latest /usr/local/lib /usr/local/lib
COPY --from=clangbuiltlinux/llvm-project:latest /usr/local/include /usr/local/include
RUN cd /usr/lib/ && \
  for library in libc++abi.so.1 libc++.a libc++abi.a libc++.so.1 libunwind.so.1 libunwind.a; \
    do ln -s "/usr/local/lib/x86_64-alpine-linux-musl/${library}" . ; \
  done

RUN apk add wget

RUN wget --no-clobber --no-verbose https://musl.libc.org/releases/musl-1.2.3.tar.gz && \
  tar xvf musl-1.2.3.tar.gz

# TODO: doesn't musl need the kernel headers?
#COPY --from=clangbuiltlinux/containers:linux /sysroot /sysroot

RUN mkdir musl-1.2.3/build
RUN cd musl-1.2.3/build && \
  CC=clang ../configure --prefix=/usr --syslibdir=/usr/lib

# TODO: build llvm-ar
RUN apk add make llvm13
RUN make -C musl-1.2.3/build -j$(nproc) AR=llvm-ar RANLIB=llvm-ranlib

RUN make -C musl-1.2.3/build -j$(nproc) DESTDIR=/sysroot install-headers

RUN make -C musl-1.2.3/build -j$(nproc) DESTDIR=/sysroot install-libs

COPY hello.c .
RUN clang --sysroot=/sysroot hello.c && ./a.out
