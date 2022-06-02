#!/usr/bin/env bash

set -eu

function checks() {
    if [[ $(id -u) -ne 0 ]]; then
        echo "[-] This script needs to be run as root!"
        exit 1
    fi

    if [[ $# -eq 0 ]]; then
        echo "[-] User name of the runner user account required as first argument!"
        exit 1
    else
        username=$1
    fi
    workspace=/home/$username/actions-runner

    # shellcheck disable=SC1091
    source /usr/lib/os-release
    case "$ID" in
        fedora) ;;
        *)
            echo "[-] $NAME has not been tested with this script!"
            exit 1
            ;;
    esac

    if [[ ! -f $workspace/svc.sh ]]; then
        echo "[-] Runner must be configured already!"
        echo '[-] Follow all "Download" steps and the first "Configure" step on the "Create self-hosted runner" page.'
        exit 1
    fi
}

function resize_rootfs() {
    echo "[+] Resizing root filesystem if necessary"
    dev_mapper=$(df -HT | grep /dev/mapper/)
    if [[ -n ${dev_mapper:-} ]]; then
        # This might fail if the volume has already been resized, don't make it
        # fatal to the script
        dev_mapper_path=$(echo "$dev_mapper" | cut -d ' ' -f 1)
        lvextend -l +100%FREE "$dev_mapper_path" || true

        dev_mapper_fs_type=$(echo "$dev_mapper" | cut -d ' ' -f 2)
        if [[ $dev_mapper_fs_type = "xfs" ]]; then
            xfs_growfs "$dev_mapper_path"
        fi
    fi
}

function update_install_packages() {
    echo "[+] Updating operating system"
    dnf update -qy

    echo "[+] Installing necessary packages"
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    dnf install -qy \
        containerd.io \
        docker-ce \
        docker-ce-cli \
        docker-compose-plugin \
        git \
        zstd
}

function configure_docker() {
    echo "[+] Configuring Docker"
    usermod -aG docker "$username"
    systemctl enable --now docker
}

function check_docker() {
    echo "[+] Verifying Docker works"
    runuser -u "$username" -- docker run --rm hello-world
}

function install_runner_service() {
    echo "[+] Installing runner systemd service"
    cd "$workspace"
    ./svc.sh install "$username"
}

function install_cleanup_sh() {
    # https://docs.github.com/en/actions/hosting-your-own-runners/running-scripts-before-or-after-a-job
    echo "[+] Setting up clean up script"

    cleanup_sh=/home/$username/cleanup.sh
    cat << 'EOF' >"$cleanup_sh"
#!/usr/bin/env bash

rm -frv "${GITHUB_WORKSPACE%/*}"
EOF
    chmod a+x "$cleanup_sh"
    chown "$username:$username" "$cleanup_sh"

    # Needed because the cleanup script runs in the context of the service
    semanage fcontext --add --type initrc_exec_t "$cleanup_sh"
    runuser -u "$username" -- restorecon -v "$cleanup_sh"

    echo "ACTIONS_RUNNER_HOOK_JOB_COMPLETED=$cleanup_sh" >>"$workspace"/.env
}

function runsvc_sh_selinux() {
    # https://github.com/actions/runner/issues/1606
    echo "[+] Adjusting SELinux context for runsvc.sh"
    runsvc_sh=$workspace/runsvc.sh
    semanage fcontext --add --type initrc_exec_t "$runsvc_sh"
    runuser -u "$username" -- restorecon -v "$runsvc_sh"
}

function start_service() {
    echo "[+] Starting GitHub Actions service"
    ./svc.sh start
}

checks "$@"
resize_rootfs
update_install_packages
configure_docker
check_docker
install_runner_service
install_cleanup_sh
runsvc_sh_selinux
start_service
