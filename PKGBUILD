# Maintainer: Jaeho Cho <jaehho@github>
pkgname=hypr-wallpaper
pkgver=1.0.0
pkgrel=1
pkgdesc='SQLite-backed, quality-gated, time-aware wallpaper manager and TUI for Hyprland'
arch=('any')
url='https://github.com/jaehho/hypr-wallpaper'
license=('MIT')
depends=('hyprland' 'python' 'jq' 'sqlite' 'curl' 'socat' 'libnotify' 'xdg-utils')
optdepends=(
    'awww: wallpaper setter daemon'
    'rofi: GUI menu mode'
    'tomlq: TOML rule parsing'
)
source=("$pkgname-$pkgver.tar.gz::$url/archive/v$pkgver.tar.gz")
sha256sums=('SKIP')

package() {
    cd "$srcdir/$pkgname-$pkgver"
    make DESTDIR="$pkgdir" PREFIX=/usr install
    install -Dm644 config/config    "$pkgdir/usr/share/$pkgname/config.default"
    install -Dm644 config/rules.toml "$pkgdir/usr/share/$pkgname/rules.toml.default"
}
