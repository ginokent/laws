SHELL = /bin/bash

.PHONY: all lint test

all: test lint

test:
	@echo .tools/test.sh
	@.tools/test.sh 2>/dev/stdout | sed "s/\(^+* .*\)/`printf '\e[34m'`\1`printf '\e[0m'`/g; s/\(^'$$\)/`printf '\e[34m'`\1`printf '\e[0m'`/g"
	@echo

lint:
	shellcheck ./lw
	@echo
