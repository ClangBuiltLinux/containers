# llvm-project

## Goals
To produce statically-linked builds of Clang and LLVM utilities supercharged
for Linux kernel development, from a series of Docker images built
continuously, that can be hosted on
[kernel.org](https://mirrors.edge.kernel.org/pub/tools/crosstool/).

### Stage N-4 goal (stage 1)
- use llvm prebuilts from alpine to bootstrap
- llvm-runtimes build (builds clang and lld, uses those to build runtimes)
- no dependency on glibc

### Stage N-3 goal (stage 2)
- build clang and lld with llvm-runtimes from stage N-4
- statically linked
- no dependency on glibc
- defaults to libc++, lld, compiler-rt, libunwind

### Stage N-2 goal (stage 3)
- statically linked
- no dependency on glibc
- no object files built from gcc
- dependencies built from source

### Stage N-1 goal (stage 4)
- only built if doing PGO
- instrumented to collect profile data from building kernels

### Stage N goal (stage 5)
- statically linked
- no dependency on glibc
- no object files built from gcc
- consumes PGO or AutoFDO data from kernel builds
- LTO
- built entirely from source

## Dependencies

### Stage 1 Dependencies
![stage 1 dependencies](https://github.com/ClangBuiltLinux/containers/tree/main/llvm-project/main/stage1.svg?raw=true)

### Stage 2 Dependencies
![stage 2 dependencies](https://github.com/ClangBuiltLinux/containers/tree/main/llvm-project/main/stage2.svg?raw=true)


## Epochs

A series of epochs are described in order to bootstrap this toolchain for
multiple different target architectures.

How Dockerfiles and github actions are split up might seem a little odd. In
order to balance github action build time vs what needs to actually be
published or not on the container registry, we have decided to break up the
pipeline into "epochs" as follows.

1. In order to initially bootstrap to stage 2, stage 1 is immediately followed
   by stage 2 in one Dockerfile. This is mostly because the llvm runtimes build
   forces us to build clang then use that to start building the runtime
   libraries (which clang doesn't itself use, since they aren't built yet).
   Stage2 is pushed to the registry.
2. A "loop" is formed in CI by using the results of the previous stage 2 now in
   the registry to rebuild stage 2, rather than re-bootstrap from stage 1.
3. The "loop" is extended to add in stage 3. The results are published to
   registry, and used rather than re-bootstrapping from stage 2.

TODO: diagrams
