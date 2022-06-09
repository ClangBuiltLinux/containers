DOCKER ?= docker

.DEFAULT_GOAL := clang

%.svg: %.dot
	dot -Tsvg $< > $@

dotfiles: stage2.svg stage1.svg

.PHONY: clang
TAG ?= clangbuiltlinux/llvm-project:latest
clang:
	$(DOCKER) build --tag $(TAG) .
	$(DOCKER) rm llvm-project || true
	$(DOCKER) create --name llvm-project $(TAG)
	$(DOCKER) cp llvm-project:/usr/local/bin/clang-14 clang
