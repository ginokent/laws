SHELL := /bin/bash
VERSION := $(shell ./laws --version | sed 's/[^[:blank:]]*[[:blank:]]*//')
RELEASE_BRANCH_NAME := release
CURRENT_BRANCH_NAME := $(shell git branch | grep ^* | sed s/^[^[:blank:]][[:blank:]]//)
TAG_LATEST_VERSION := $(shell git tag | grep -E "[0-9]+\.[0-9]+\.[0-9]+" | sort -V | tail -1)

.PHONY: readme release shellcheck test test.sh

shellcheck:
	@printf "\e[1;37m%s\e[0m\n" "`LANG=C date` [TEST]  -- shellcheck ./laws Testing... ----------------"
	@shellcheck ./laws \
		&& { printf   "\e[32m%s\e[0m\n" "`LANG=C date` [INFO]  -- shellcheck ./laws Passed ----------------"; } \
		|| { printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] == shellcheck ./laws Failed ================"; false; }

test: test.sh shellcheck readme

test.sh:
	@./test/test.sh

readme:
	@printf "\e[1;37m%s\e[0m\n" "`LANG=C date` [TEST]  -- git diff ./README.md Testing... ----------------"
	@./laws 2>&1 | tee ./README.md >/dev/null
	@git diff ./README.md \
		&& { printf   "\e[32m%s\e[0m\n" "`LANG=C date` [INFO]  -- git diff ./README.md Passed ----------------"; } \
		|| { printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] == git diff ./README.md Failed ================"; false; }

tag: test
	@printf "\e[1;37m%s\e[0m\n" "`LANG=C date` [TEST]  -- git tag -a ${VERSION} -m 'release ${VERSION}' ----------------"
	@[ "${VERSION}" != "${TAG_LATEST_VERSION}" ] \
		&& { git checkout release; git tag -a ${VERSION} -m 'release ${VERSION}'; git checkout ${CURRENT_BRANCH_NAME}; } \
		|| { printf   "\e[33m%s\e[0m\n" "`LANG=C date` [WARN]  == tag ${VERSION} already exist ================"; }
	@printf   "\e[32m%s\e[0m\n" "`LANG=C date` [INFO]  -- git tag -a ${VERSION} -m 'release ${VERSION}' Passed ----------------"

release:
	@printf "\e[1;37m%s\e[0m\n" "`LANG=C date` [TEST]  -- git push origin ${VERSION} ----------------"
	@git push origin ${VERSION}
	@printf   "\e[32m%s\e[0m\n" "`LANG=C date` [INFO]  -- git push origin ${VERSION} Passed ----------------"


