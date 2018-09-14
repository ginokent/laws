SHELL := /bin/bash
GIT_ROOT_DIR := $(shell echo "`pwd`/`git rev-parse --show-cdup`")

.PHONY: readme release syntax test test.sh

test: init readme syntax test.sh

init:
	@cp -af "${GIT_ROOT_DIR}/.tools/git/hooks/pre-commit" "${GIT_ROOT_DIR}/.git/hooks/pre-commit"

readme:
	@printf "\e[1;37m%s\e[0m\n" "`LANG=C date` [TEST]  -- git diff README.md Testing... ----------------"
	@./laws 2>&1 | tee ./README.md >/dev/null
	@[ -z "`git diff ./README.md`" ] \
		&& {                       printf "\e[1;32m%s\e[0m\n" "`LANG=C date` [INFO]  -- git diff README.md Passed ----------------"; } \
		|| { git diff ./README.md; printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] == git diff README.md Failed ================"; false; }

syntax:
	@./.tools/syntax.sh

test.sh:
	@time ./.tools/test.sh

release: test
	@./.tools/release.sh

force-release: test
	git tag -d $(shell laws version | sed s/^[^[:blank:]]*[[:blank:]]//) && git push origin :$(shell laws version | sed s/^[^[:blank:]]*[[:blank:]]//)
	@./.tools/release.sh
