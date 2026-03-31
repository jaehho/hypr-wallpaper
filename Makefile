PREFIX  ?= $(HOME)/.local
CONFDIR ?= $(HOME)/.config/hypr-wallpaper
AUR_DIR ?= $(HOME)/aur/hypr-wallpaper-git

CURRENT_TAG := $(shell git describe --tags --abbrev=0 2>/dev/null || echo v0.0.0)
CURRENT_VER := $(CURRENT_TAG:v%=%)
MAJOR := $(word 1,$(subst ., ,$(CURRENT_VER)))
MINOR := $(word 2,$(subst ., ,$(CURRENT_VER)))
PATCH := $(word 3,$(subst ., ,$(CURRENT_VER)))

install: install-bin install-config

install-bin:
	install -Dm755 bin/hypr-wallpaper $(DESTDIR)$(PREFIX)/bin/hypr-wallpaper
	install -Dm755 bin/hypr-wallpaper-menu $(DESTDIR)$(PREFIX)/bin/hypr-wallpaper-menu

install-config:
	install -dm755 $(DESTDIR)$(CONFDIR)
	test -f $(DESTDIR)$(CONFDIR)/config    || install -m644 config/config    $(DESTDIR)$(CONFDIR)/config
	test -f $(DESTDIR)$(CONFDIR)/rules.toml || install -m644 config/rules.toml $(DESTDIR)$(CONFDIR)/rules.toml

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/hypr-wallpaper
	rm -f $(DESTDIR)$(PREFIX)/bin/hypr-wallpaper-menu

release-major: V=$(shell echo $$(($(MAJOR)+1))).0.0
release-major: _release ## Bump major version (1.2.3 → 2.0.0)

release-minor: V=$(MAJOR).$(shell echo $$(($(MINOR)+1))).0
release-minor: _release ## Bump minor version (1.2.3 → 1.3.0)

release-patch: V=$(MAJOR).$(MINOR).$(shell echo $$(($(PATCH)+1)))
release-patch: _release ## Bump patch version (1.2.3 → 1.2.4)

_release:
	@test -z "$$(git status --porcelain)" || { echo "Error: working tree not clean — commit first"; exit 1; }
	@test -d "$(AUR_DIR)/.git" || { echo "Error: AUR repo not found at $(AUR_DIR)"; exit 1; }
	@echo "==> $(CURRENT_VER) → $(V)"
	git tag v$(V)
	git push && git push --tags
	@echo "==> Updating AUR..."
	cp PKGBUILD $(AUR_DIR)/PKGBUILD
	cd $(AUR_DIR) && makepkg --printsrcinfo > .SRCINFO && \
		git add PKGBUILD .SRCINFO && \
		git commit -m "Update to $(V)" && \
		git push origin HEAD:master
	@echo "==> Released v$(V)"

.PHONY: install install-bin install-config uninstall release-major release-minor release-patch _release
