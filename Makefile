SHELL = /bin/bash

.PHONY: all shellcheck test

all: test shellcheck readme

test:
	@echo [TEST] .tools/test.sh
	@.tools/test.sh
	@echo

shellcheck:
	@echo [TEST] shellcheck ./lw
	@shellcheck ./lw && { printf "\n\e[32m%s\e[0m\n" "`LANG=C date` [INFO]  -- Passed test ----------------"; } || { printf "\n\e[31m%s\e[0m\n" "`LANG=C date` [ERROR] -- Failed test ----------------"; false; }
	@echo

readme:
	@echo [TEST] git diff ./README.md
	@./lw 2>&1 | tee ./README.md >/dev/null
	@git diff ./README.md && { printf "\n\e[32m%s\e[0m\n" "`LANG=C date` [INFO]  -- Passed test ----------------"; } || { printf "\n\e[31m%s\e[0m\n" "`LANG=C date` [ERROR] -- Failed test ----------------"; false; }
	@echo
