PREFIX  ?= $(HOME)/.local
CONFDIR ?= $(HOME)/.config/hypr-wallpaper

install:
	install -Dm755 bin/hypr-wallpaper $(DESTDIR)$(PREFIX)/bin/hypr-wallpaper
	install -Dm755 bin/hypr-wallpaper-menu $(DESTDIR)$(PREFIX)/bin/hypr-wallpaper-menu
	install -dm755 $(DESTDIR)$(CONFDIR)
	test -f $(DESTDIR)$(CONFDIR)/config    || install -m644 config/config    $(DESTDIR)$(CONFDIR)/config
	test -f $(DESTDIR)$(CONFDIR)/rules.toml || install -m644 config/rules.toml $(DESTDIR)$(CONFDIR)/rules.toml

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/hypr-wallpaper
	rm -f $(DESTDIR)$(PREFIX)/bin/hypr-wallpaper-menu

.PHONY: install uninstall
