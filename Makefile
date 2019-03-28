SHELL := /bin/bash
GIT_ROOT_DIR := $(shell echo "`pwd`/`git rev-parse --show-cdup`")
HOST := $(shell echo ${HOST})

.PHONY: init readme release release-force syntax test test-ec2

##
# test
##
test: init readme syntax
	@time ./.tools/test.sh

test-ec2:
	@./.tools/test-ec2.sh

test-all: test test-ec2

init:
	@cp -af "${GIT_ROOT_DIR}/.tools/git/hooks/pre-commit" "${GIT_ROOT_DIR}/.git/hooks/pre-commit"

readme:
	@printf "\e[1;37m%s\e[0m\n" "`LANG=C date` [TEST]  -- git diff README.md Testing ----------------"
	@./laws help 2>&1 | tee ./README.md >/dev/null
	@[ -z "`git diff ./README.md`" ] \
		&& {                       printf "\e[1;32m%s\e[0m\n" "`LANG=C date` [INFO]  -- git diff README.md Passed ----------------"; } \
		|| { git diff ./README.md; printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] == git diff README.md Failed ================"; false; }

syntax:
	@./.tools/syntax.sh

merge:
	CurrentBrunch=`git branch | grep ^* | sed s/^[^[:blank:]][[:blank:]]//` && \
		git push && \
		git checkout develop && \
		git merge $${CurrentBrunch} && \
		git push && \
		git checkout master && \
		git merge develop && \
		git push && \
		git checkout $${CurrentBrunch}

##
# release
##
release: test
	@./.tools/release.sh

release-force: test
	@git tag -d `laws version | sed s/^[^[:blank:]]*[[:blank:]]//` && git push origin :`laws version | sed s/^[^[:blank:]]*[[:blank:]]//`
	@./.tools/release.sh
