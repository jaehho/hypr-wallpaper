PREFIX  ?= $(HOME)/.local
CONFDIR ?= $(HOME)/.config/hypr-wallpaper

AUR_PKG  := hypr-wallpaper-git
AUR_REPO := ssh://aur@aur.archlinux.org/$(AUR_PKG).git

include hypr-tui/release.mk

install: install-bin install-config

install-bin:
	install -Dm755 bin/hypr-wallpaper $(DESTDIR)$(PREFIX)/bin/hypr-wallpaper
	install -Dm755 bin/hypr-wallpaper-menu $(DESTDIR)$(PREFIX)/bin/hypr-wallpaper-menu
	install -dm755 $(DESTDIR)$(PREFIX)/lib/hypr-wallpaper/hypr_tui
	install -m644 hypr-tui/hypr_tui/__init__.py $(DESTDIR)$(PREFIX)/lib/hypr-wallpaper/hypr_tui/__init__.py

install-config:
	install -dm755 $(DESTDIR)$(CONFDIR)
	test -f $(DESTDIR)$(CONFDIR)/config    || install -m644 config/config    $(DESTDIR)$(CONFDIR)/config
	test -f $(DESTDIR)$(CONFDIR)/rules.toml || install -m644 config/rules.toml $(DESTDIR)$(CONFDIR)/rules.toml

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/hypr-wallpaper
	rm -f $(DESTDIR)$(PREFIX)/bin/hypr-wallpaper-menu
	rm -rf $(DESTDIR)$(PREFIX)/lib/hypr-wallpaper

.PHONY: install install-bin install-config uninstall
