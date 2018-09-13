SHELL := /bin/bash

.PHONY: readme release syntax test test.sh

test: readme syntax test.sh

syntax:
	@./.tools/syntax.sh

readme:
	@printf "\e[1;37m%s\e[0m\n" "`LANG=C date` [TEST]  -- git diff README.md Testing... ----------------"
	@./laws 2>&1 | tee ./README.md >/dev/null
	@[ -z "`git diff ./README.md`" ] \
		&& {                       printf "\e[1;32m%s\e[0m\n" "`LANG=C date` [INFO]  -- git diff README.md Passed ----------------"; } \
		|| { git diff ./README.md; printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] == git diff README.md Failed ================"; false; }

test.sh:
	@./.tools/test.sh

release: test
	@./.tools/release.sh
