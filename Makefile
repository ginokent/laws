SHELL = /bin/bash

.PHONY: readme shellcheck test

shellcheck:
	@printf "\e[1;37m%s\e[0m\n" "`LANG=C date` [TEST]  -- shellcheck ./laws Testing... ----------------"
	@shellcheck ./laws \
		&& { printf   "\e[32m%s\e[0m\n" "`LANG=C date` [INFO]  -- shellcheck ./laws Passed ----------------"; } \
		|| { printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] == shellcheck ./laws Failed ================"; false; }

test: test.sh shellcheck readme version

test.sh:
	@./test/test.sh

readme:
	@printf "\e[1;37m%s\e[0m\n" "`LANG=C date` [TEST]  -- git diff ./README.md Testing... ----------------"
	@./laws 2>&1 | tee ./README.md >/dev/null
	@git diff ./README.md \
		&& { printf   "\e[32m%s\e[0m\n" "`LANG=C date` [INFO]  -- git diff ./README.md Passed ----------------"; } \
		|| { printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] == git diff ./README.md Failed ================"; false; }

version:
	git tag
	./laws --version
