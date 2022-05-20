#!/usr/bin/env sh
docker build --tag clangbuiltlinux/llvm-project:latest .
docker cp llvm-project:/usr/local/bin/clang-14 clang
