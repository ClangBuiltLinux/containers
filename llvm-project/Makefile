.DEFAULT_GOAL := clang

%.svg: %.dot
	dot -Tsvg $< > $@

dotfiles: stage2.svg stage1.svg

.PHONY: clang
clang:
	docker build --tag clangbuiltlinux/llvm-project:latest .
	docker create --name llvm-project clangbuiltlinux/llvm-project:latest || true
	docker cp llvm-project:/usr/local/bin/clang-14 clang
