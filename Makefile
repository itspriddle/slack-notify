DIRS=bin share
INSTALL_DIRS=`find $(DIRS) -type d`
INSTALL_FILES=`find $(DIRS) -type f`

PREFIX?=/usr/local

VERSION?=$(error Must specify version, eg: VERSION=v0.0.0)

.PHONY: help
help: ## show this help text
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: test
test: shellcheck bats ## run full test suite

.PHONY: shellcheck
shellcheck: ## run shellcheck tests
	shellcheck -s bash bin/slack-notify test/*.bats test/*.bash

.PHONY: bats
bats: ## run bats tests
	./test/bats/bin/bats test

.PHONY: bootstrap
bootstrap: ## bootstrap for development/test
	gem install kramdown-man
	./test/setup

share/man/man1/slack-notify.1: doc/man/slack-notify.1.md
	kramdown-man doc/man/slack-notify.1.md > share/man/man1/slack-notify.1

.PHONY: man
man: share/man/man1/slack-notify.1 ## generate man file using kramdown-man

.PHONY: install
install: ## install the program
	for dir in $(INSTALL_DIRS); do mkdir -p $(DESTDIR)$(PREFIX)/$$dir; done
	for file in $(INSTALL_FILES); do cp $$file $(DESTDIR)$(PREFIX)/$$file; done

.PHONY: uninstall
uninstall: ## uninstall the program
	for file in $(INSTALL_FILES); do rm -f $(DESTDIR)$(PREFIX)/$$file; done

.PHONY: archive
archive: ## create a zip archive of the current version
	mkdir -p pkg
	git archive --prefix=slack-notify-$(VERSION)/ --output=pkg/slack-notify-$(VERSION).zip $(VERSION) $(INSTALL_FILES)

.PHONY: release
release: ## create a new tag and push to GitHub
	git tag -m "$(VERSION)" $(VERSION)
	git push --tags
