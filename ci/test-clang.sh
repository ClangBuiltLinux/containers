#!/usr/bin/env bash

set -eu

trap 'rm -fr "$toolchain"' EXIT

# Set up workspace
rootdir=${GITHUB_WORKSPACE:-$(dirname "$(dirname "$(realpath "$0")")")}
toolchain=$rootdir/toolchain

# Pull toolchain out of container
echo "[+] Downloading toolchain from container"
docker create --name llvm-project ghcr.io/clangbuiltlinux/llvm-project:stage2
mkdir "$toolchain"
docker cp llvm-project:/usr/local/bin "$toolchain"
docker cp llvm-project:/usr/local/include "$toolchain"
docker cp llvm-project:/usr/local/lib "$toolchain"
echo "[+] Cleaning up container"
docker rm llvm-project

# Test toolchain in Docker images so that the environment is consistent,
# regardless of runners.
docker_images=(
    docker.io/fedora:latest
)
# Arch Linux is an x86_64-only distribution
[[ $(uname -m) = "x86_64" ]] && docker_images+=(docker.io/archlinux:latest)
for docker_image in "${docker_images[@]}"; do
    echo "[+] Updating '$docker_image'"
    docker pull "$docker_image"
    echo "[+] Testing clang in '$docker_image' container"
    docker run \
        --rm \
        --volume "$rootdir":/repo:ro \
        "$docker_image" \
        bash /repo/ci/test-clang-docker.sh
done
