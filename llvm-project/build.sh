#!/usr/bin/env sh
wget --no-clobber https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.1/llvm-project-14.0.1.src.tar.xz
docker build --tag clangbuiltlinux/llvm-project:latest . -f Dockerfile.bootstrap
docker cp llvm-project:/usr/local/bin/clang-14 clang
