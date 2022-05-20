#!/usr/bin/env sh
docker build --tag clangbuiltlinux/llvm-project:latest .
#docker create --name llvm-project clangbuiltlinux/llvm-project:latest
#docker cp llvm-project:/usr/local/bin/clang-14 clang
dot -Tsvg stage1.dot > stage1.svg
dot -Tsvg stage2.dot > stage2.svg
