FROM docker.io/archlinux:base

RUN sed -i "/\[testing\]/,/Include/"'s/^#//' /etc/pacman.conf && \
    pacman -Syyu --noconfirm && \
    pacman -S --noconfirm \
        binutils \
        git \
        python \
        python-yaml \
        qemu-system-aarch64 \
        qemu-system-arm \
        qemu-system-mips \
        qemu-system-ppc \
        qemu-system-riscv \
        qemu-system-s390x \
        qemu-system-x86 \
        zstd
