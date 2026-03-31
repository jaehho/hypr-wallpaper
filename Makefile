PREFIX  ?= $(HOME)/.local
CONFDIR ?= $(HOME)/.config/hypr-wallpaper
AUR_DIR ?= $(HOME)/aur/hypr-wallpaper-git

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

release: ## Tag, push, and publish to AUR (make release V=x.y.z)
	@test -n "$(V)" || { echo "Usage: make release V=1.1.0"; exit 1; }
	@test -z "$$(git status --porcelain)" || { echo "Error: working tree not clean — commit first"; exit 1; }
	@test -d "$(AUR_DIR)/.git" || { echo "Error: AUR repo not found at $(AUR_DIR)"; exit 1; }
	@echo "==> Tagging v$(V)..."
	git tag v$(V)
	git push && git push --tags
	@echo "==> Updating AUR..."
	cp PKGBUILD $(AUR_DIR)/PKGBUILD
	cd $(AUR_DIR) && makepkg --printsrcinfo > .SRCINFO && \
		git add PKGBUILD .SRCINFO && \
		git commit -m "Update to $(V)" && \
		git push origin HEAD:master
	@echo "==> Released v$(V)"

.PHONY: install install-bin install-config uninstall release
