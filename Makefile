SHELL := /bin/bash
GIT_ROOT_DIR := $(shell echo "`pwd`/`git rev-parse --show-cdup`")
HOST := $(shell echo ${HOST})


.PHONY: help
.DEFAULT_GOAL := help
help:  ## このドキュメントを表示します。
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2}' | sed 's/{{ENVIRONMENT}}/${ENVIRONMENT}/g'

##
# test
##
.PHONY: init
init:  ## 開発環境を初期化します。
	@cp -af "${GIT_ROOT_DIR}/.tools/git/hooks/pre-commit" "${GIT_ROOT_DIR}/.git/hooks/pre-commit"

.PHONY: readme
readme:  ## README.md を laws コマンドの内容で上書きます。
	@printf "\e[1;37m%s\e[0m\n" "`LANG=C date` [TEST]  -- git diff README.md Testing ----------------"
	@./laws help 2>&1 | tee ./README.md >/dev/null
	@[ -z "`git diff ./README.md`" ] \
		&& {                       printf "\e[1;32m%s\e[0m\n" "`LANG=C date` [INFO]  -- git diff README.md Passed ----------------"; } \
		|| { git diff ./README.md; printf "\e[1;31m%s\e[0m\n" "`LANG=C date` [ERROR] == git diff README.md Failed ================"; false; }

.PHONY: syntax
syntax:
	@./.tools/syntax.sh

.PHONY: test
test: init readme syntax ## テストを実行します。
	@time ./.tools/test.sh

.PHONY: test-ec2 ## EC2上でテストを実行します。
test-ec2:
	@./.tools/test-ec2.sh

##
# release
##
.PHONY: merge
merge:  ## いい感じに merge します。
	CurrentBrunch=`git branch | grep ^* | sed s/^[^[:blank:]][[:blank:]]//` && \
		git push && \
		git checkout develop && \
		git merge $${CurrentBrunch} && \
		git push && \
		git checkout master && \
		git merge develop && \
		git push && \
		git checkout $${CurrentBrunch}

.PHONY: release
release: test ## laws --version で出力されるバージョンでタグを打ちます。
	@./.tools/release.sh

.PHONY: release-force
release-force: test ## laws --version で出力されるバージョンでタグを打ちます（既に存在する場合は上書きます）。
	@git tag -d `laws version | sed s/^[^[:blank:]]*[[:blank:]]//` && git push origin :`laws version | sed s/^[^[:blank:]]*[[:blank:]]//`
	@./.tools/release.sh

