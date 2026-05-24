pkgname="sddm-theme-axos"
pkgver="5.0"
pkgrel="1"
pkgdesc="sddm theme for AxOS"
arch=("x86_64")
depends=("sddm" "qt5-quickcontrols" "qt5-graphicaleffects" "quickshell")

package(){
   mkdir -p ${pkgdir}/usr/share/sddm/themes/axos
   cp -r ${srcdir}/* ${pkgdir}/usr/share/sddm/themes/axos
}
