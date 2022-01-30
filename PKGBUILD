# Maintainer: Suren Kirakosyan <surenkirakosyan.am@gmail.com>

pkgname=sarqx-reporter
pkgver=0.0.1
pkgrel=1
pkgdesc="CLI application."
arch=(i686 x86_64)
url=https://gitlab.com/sarqx_group/sarqx-reporter
license=('GPL')
depends=('erlang' 'elixir')
checkdepends=('systemd')
makedepends=(git make)
provides=($pkgname=$pkgver)
conflicts=($pkgname)

prepare() {
  git clone git@gitlab.com:sarqx_group/sarqx-reporter.git
}

build() {
  cd $pkgname

  make install
}

package() {
  cd $pkgname

  mkdir -p "$pkgdir"/usr/bin
  install -Dm755 sarqx-reporter "$pkgdir"/usr/bin
}
