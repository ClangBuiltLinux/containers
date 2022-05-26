#!/usr/bin/env bash

set -eu

if [[ ! -d /repo ]]; then
    echo "[-] This script needs to be run within Docker! Use test-clang.sh instead."
    exit 1
fi

CC=/repo/toolchain/bin/clang
CXX=/repo/toolchain/bin/clang++
hello_c=/repo/llvm-project/hello.c
hello_cpp=/repo/llvm-project/hello.cpp
hello_exe=/tmp/hello
host_arch=$(uname -m)

# Print clang information, which makes sure it can run
echo "[+] Testing 'clang --version'"
"$CC" --version

case "$(source /usr/lib/os-release; echo "$ID")" in
    fedora)
        musl_cc_flags=(
            -B /usr/"$host_arch"-linux-musl/lib64   # Scrt1.o, crti.o, crtn.o
            -I /usr/"$host_arch"-linux-musl/include # stdio.h
            -L /usr/"$host_arch"-linux-musl/lib64   # -lc
        )

        echo "[+] Updating OS"
        dnf update -qy

        echo "[+] Installing musl"
        dnf install -qy \
            musl-devel \
            musl-libc \
            musl-libc-static
        ;;
esac

########
# MUSL #
########

echo "[+] Testing dynamically linking hello.c against musl"
"$CC" "${musl_cc_flags[@]}" -o "$hello_exe" "$hello_c"
"$hello_exe"

echo "[+] Testing statically linking hello.c against musl"
"$CC" "${musl_cc_flags[@]}" -static -o "$hello_exe" "$hello_c"
"$hello_exe"

echo "[+] Testing dynamically linking hello.cpp against musl ('--rpath')"
# --rpath to avoid having to pull in libc++ and libunwind from distribution
"$CXX" "${musl_cc_flags[@]}" -Wl,--rpath=/repo/toolchain/lib/"$host_arch"-alpine-linux-musl -o "$hello_exe" "$hello_cpp"
"$hello_exe"

echo "[+] Testing dynamically linking hello.cpp against musl ('LD_LIBRARY_PATH')"
"$CXX" "${musl_cc_flags[@]}" -o "$hello_exe" "$hello_cpp"
LD_LIBRARY_PATH=/lib:/repo/toolchain/lib/"$host_arch"-alpine-linux-musl "$hello_exe"

echo "[+] Testing statically linking hello.cpp against musl"
"$CXX" "${musl_cc_flags[@]}" -static -lc++abi -o "$hello_exe" "$hello_cpp"
"$hello_exe"
