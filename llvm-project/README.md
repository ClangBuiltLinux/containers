# llvm-project

## Goals
To produce statically-linked builds of Clang and LLVM utilities supercharged
for Linux kernel development, from a series of Docker images built
continuously, that can be hosted on
[kernel.org](https://mirrors.edge.kernel.org/pub/tools/crosstool/).

## The build

### Stage 0

Stage 0 uses docker containers of alpine linux. Alpine is relatively small
but has a package manager and some prebuilts we can use. So the stage 0
toolchain comes from Alpine prebuilt.

Pros:
- prebuilts available from package manager
- musl based already
Cons:
- is dynamically linked
  - depends on libclang-cpp and libLLVM
  - depends on libstdc++
  - depends on libgcc_s
- can't compile C++ hello world due to broken dependencies on libstdc++ headers
- was built with GCC.

### Stage 1

The stage 1 build is a throwaway build; it's the initial time we build clang
and lld from source, but it still depends on libstdc++ (alpine doesn't package
libc++) and libgcc_s. This build of clang is used to build the "LLVM Runtimes"
(compiler builtins, compiler-rt, libunwind, libcxxabi, libc++) and compiler
"resource" headers.

Red nodes in the following graphs are prebuilts from alpine. Red edges are
dependencies we'd like to remove in following stages.

![stage 1 dependencies](https://github.com/ClangBuiltLinux/containers/blob/main/llvm-project/stage1.svg?raw=true)

This build of clang defaults to `-fuse-ld=lld` and `--rtlib=compiler-rt`, but
not yet `--stdlib=libc++` or `--unwindlib=libunwind` because they are not
available in stage 0; we are going to build them from source as stage 1.
The stage 1 build of clang is still dynamically linked, but at least it was
built with clang and lld (from stage 0).

### Stage 2

The stage build is the first attempt at producing a fully statically linked
build of clang, using our runtimes built from source in stage 1, and with
the desired defaults set.

![stage 2 dependencies](https://github.com/ClangBuiltLinux/containers/blob/main/llvm-project/stage2.svg?raw=true)

Unfortunately, it's still not entirely built from source yet (sources outside
of llvm-project have just been statically linked against). That will be the
goal for stage 3.

### Stage 3

The goal for stage 3 is to reproduce a similar result to stage 2, but
entirely built from source. This will involve rebuilding linux kernel headers,
zlib, and musl from source. The resulting binary should only have been compiled
by clang.

### Stage 4

Stage 4 will be an optional build, only built if doing PGO. It will be
instrumented to collect profile data from building kernels. It's not meant to
be distributed.

### Stage 5

Is similar to stage 3, but built with the profile data from collected from
stage 4. We might also LTO this stage.

## Epochs

A series of epochs are described in order to bootstrap this toolchain for
multiple different target architectures.

How Dockerfiles and github actions are split up might seem a little odd. In
order to balance github action build time vs what needs to actually be
published or not on the container registry, we have decided to break up the
pipeline into "epochs" as follows.

1. In order to initially bootstrap to stage 2, stage 1 is immediately
   followed by stage 2 in one Dockerfile. This is mostly because the llvm
   runtimes build forces us to build clang then use that to start building the
   runtime libraries (which clang doesn't itself use, since they aren't built
   yet).  Stage 2 is pushed to the registry.
2. A "loop" is formed in CI by using the results of the previous stage 2 now in
   the registry to rebuild stage 2, rather than re-bootstrap from stage 1.
3. The "loop" is extended to add in stage 3. The results are published to
   registry, and used rather than re-bootstrapping from stage 2.

TODO: diagrams
