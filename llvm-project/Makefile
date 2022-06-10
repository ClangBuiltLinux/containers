DOCKER ?= docker
HOST_ARCH := $(shell uname -m)
IMAGE ?= ghcr.io/clangbuiltlinux/llvm-project

.DEFAULT_GOAL := clang

%.svg: %.dot
	dot -Tsvg $< > $@

dotfiles: stage2.svg stage1.svg

.PHONY: clang epoch1 epoch2 epoch3

# Argument 1: epoch# (e.g., epoch1; should match the suffix of the Dockerfile)
# Argument 2: Tag (e.g., ghcr.io/clangbuiltlinux/llvm-project:stage2-x86_64)
# Argument 3 (optional): Tag of previous epoch to build current epoch from.
epoch_cmd = \
	$(DOCKER) build \
		$(if $(3),--build-arg BASE=$(3)) \
		--file Dockerfile.$(1) \
		--tag $(2) \
		. && \
	bash ../ci/test-clang.sh $(2)

epoch1:
	$(call epoch_cmd,$@,$(IMAGE):stage2-$(HOST_ARCH))

epoch2:
	$(call epoch_cmd,$@,$(IMAGE):stage2-$(HOST_ARCH),$(IMAGE):stage2-$(HOST_ARCH))

epoch3:
	$(call epoch_cmd,$@,$(IMAGE):stage3-$(HOST_ARCH),$(IMAGE):stage2-$(HOST_ARCH))

clang: epoch3
	$(DOCKER) rm llvm-project || true
	$(DOCKER) create --name llvm-project $(IMAGE):stage3-$(HOST_ARCH)
	$(DOCKER) cp llvm-project:/usr/local/bin/clang-14 clang
