#!/usr/bin/env python3

import argparse
import os
import platform
from pathlib import Path
import shutil
import subprocess


def parse_parameters():
    parser = argparse.ArgumentParser(
        description=
        "Install a Fedora virtual machine using libvirt and virt-install.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument("-c",
                        "--cpus",
                        help="Number of CPUs for virtual machine",
                        type=int,
                        default=int(os.cpu_count() / 2))
    parser.add_argument("-m",
                        "--memory",
                        help="Memory amount in gigabytes for virtual machine",
                        type=int,
                        default=os.cpu_count())
    parser.add_argument("-n",
                        "--name",
                        help="Name of virtual machine",
                        type=str,
                        default="fedora")
    parser.add_argument("-s",
                        "--size",
                        help="Disk size in gigabytes for virtual machine",
                        type=int,
                        default=150)

    return parser.parse_args()


def check_requirements():
    for command in ["virsh", "virt-install"]:
        if not shutil.which(command):
            raise RuntimeError(
                "{} could not be found! Install and set up libvirt?".format(
                    command))

    if not Path("/dev/kvm").exists():
        raise RuntimeError(
            "This script requires KVM but /dev/kvm could not be found!")


def main():
    args = parse_parameters()

    check_requirements()

    host_arch = platform.machine()
    if host_arch == "aarch64":
        cpu = "host-passthrough"  # https://bugzilla.redhat.com/show_bug.cgi?id=1531076
        console = "console=ttyAMA0,115200"
    elif host_arch == "x86_64":
        cpu = "host"
        console = "console=ttyS0"
    else:
        raise RuntimeError("This script does not support {}".format(host_arch))

    virt_install = ["virt-install"]
    virt_install += ["--boot", "uefi"]
    virt_install += ["--console", "pty,target_type=serial"]
    virt_install += ["--cpu", cpu]
    virt_install += ["--disk", "size={},format=qcow2".format(args.size)]
    virt_install += ["--extra-args", console]
    virt_install += ["--graphics", "none"]
    virt_install += [
        "--location",
        "https://download.fedoraproject.org/pub/fedora/linux/releases/36/Server/{}/os"
        .format(host_arch)
    ]
    # libvirt expects MiB; str cast here and '--vcpus' is to avoid:
    # TypeError: expected str, bytes or os.PathLike object, not int
    virt_install += ["--memory", str(args.memory * 1024)]
    virt_install += ["--name", args.name]
    virt_install += ["--network", "network=default"]
    virt_install += ["--vcpus", str(args.cpus)]
    virt_install += ["--virt-type", "kvm"]

    subprocess.run(virt_install, check=True)
    subprocess.run(["virsh", "autostart", args.name], check=True)


if __name__ == '__main__':
    main()
