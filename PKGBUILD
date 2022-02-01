# Maintainer: Suren Kirakosyan <surenkirakosyan.am@gmail.com>

pkgname=sarqx-reporter
pkgver=0.0.1
pkgrel=1
pkgdesc="CLI application."
arch=(i686 x86_64)
url=https://gitlab.com/sarqx_group/sarqx-reporter
license=('GPL')
depends=('erlang' 'elixir' 'dmidecode')
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

  # TODO: maybe I should change permission of bin files
  mkdir -p $pkgdir/opt/$pkgname/bin
  install -Dm755 $pkgname $pkgdir/opt/$pkgname/bin

  mkdir -p $pkgdir/usr/bin/
  ln -s /opt/$pkgname/bin/$pkgname $pkgdir/usr/bin/$pkgname

  mkdir -p "$pkgdir"/var/opt/"$pkgname"/logs
  # HELP: chmod 600 provides read and write permission for user
  chmod 644 $pkgdir/var/opt/$pkgname/logs

  # HELP: store config files
  mkdir -p $pkgdir/etc/opt/$pkgname
  chmod 600 $pkgdir/etc/opt/$pkgname

  mkdir -p $pkgdir/etc/systemd/system
  install -Dm644 sarqxd.service $pkgdir/etc/systemd/system/

  # pkgdesc='GTK+3 implementation of wxWidgets API for GUI'
  # depends=('gtk3' 'gst-plugins-base-libs' 'libsm' 'libxxf86vm' 'libnotify')
  # optdepends=('webkit2gtk: for webview support')
  # conflicts=('wxgtk<3.0.3.1-2' 'wxgtk3')
  # provides=('wxgtk3')
}
