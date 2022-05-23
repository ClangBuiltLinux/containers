.DEFAULT_GOAL := clang

%.svg: %.dot
	dot -Tsvg $< > $@

dotfiles: stage2.svg stage1.svg

.PHONY: clang
TAG ?= clangbuiltlinux/llvm-project:latest
clang:
	docker build --tag $(TAG) .
	docker rm llvm-project || true
	docker create --name llvm-project $(TAG)
	docker cp llvm-project:/usr/local/bin/clang-14 clang
