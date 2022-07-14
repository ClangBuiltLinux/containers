#!/usr/bin/env sh

LLVM_LIBC=$(find . -name libllvmlibc.a)
for i in strlen memcmp memset memcpy; do
  llvm-ar x "${LLVM_LIBC}" $i.cpp.o
done
rm -f libllvmlibc-sparse.a
llvm-ar qc libllvmlibc-sparse.a memcmp.cpp.o memcpy.cpp.o memset.cpp.o strlen.cpp.o
