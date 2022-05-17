FROM alpine:edge

# TODO: change to container registry
COPY --from=clangbuiltlinux/containers:llvm-project llvm-project/llvm/build/bin /usr/local/bin
COPY --from=clangbuiltlinux/containers:llvm-project /usr/local/lib /usr/local/lib
COPY --from=clangbuiltlinux/containers:llvm-project /usr/local/include /usr/local/include
RUN cd /usr/lib/ && \
  for library in libc++abi.so.1 libc++.a libc++abi.a libc++.so.1 libunwind.so.1 libunwind.a; \
    do ln -s "/usr/local/lib/x86_64-alpine-linux-musl/${library}" . ; \
  done

RUN apk add wget

RUN wget --no-clobber --no-verbose https://git.kernel.org/torvalds/t/linux-5.18-rc6.tar.gz && \
  tar xvf linux-5.18-rc6.tar.gz

RUN apk add make musl-dev rsync

RUN make -C linux-5.18-rc6 INSTALL_HDR_PATH=/sysroot/usr LLVM=1 -j$(nproc) headers_install
RUN apk del rsync musl-dev make wget
