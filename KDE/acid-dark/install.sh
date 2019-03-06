#!/bin/sh

set -e

gh_repo="acid-dark"
gh_desc="Acid Dark KDE"
gh_base_repo="https://github.com/Stefan-Z-Camilleri/themes/tree/master/KDE/"

cat <<- EOF

   █████╗  ██████╗██╗██████╗     ██████╗  █████╗ ██████╗ ██╗  ██╗
  ██╔══██╗██╔════╝██║██╔══██╗    ██╔══██╗██╔══██╗██╔══██╗██║ ██╔╝
  ███████║██║     ██║██║  ██║    ██║  ██║███████║██████╔╝█████╔╝ 
  ██╔══██║██║     ██║██║  ██║    ██║  ██║██╔══██║██╔══██╗██╔═██╗ 
  ██║  ██║╚██████╗██║██████╔╝    ██████╔╝██║  ██║██║  ██║██║  ██╗
  ╚═╝  ╚═╝ ╚═════╝╚═╝╚═════╝     ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝

  $gh_desc
  ${gh_base_repo}${gh_repo}

EOF

PREFIX=${PREFIX:=/usr}
uninstall=${uninstall:-false}

_msg() {
    echo "=>" "$@" >&2
}

_rm() {
    # removes parent directories if empty
    sudo rm -rf "$1"
    sudo rmdir -p "$(dirname "$1")" 2>/dev/null || true
}

_uninstall() {
    _msg "Deleting $gh_desc ..."
    _rm "$PREFIX/share/aurorae/themes/Acid-Dark"
    _rm "$PREFIX/share/color-schemes/Acid-Dark.colors"
    _rm "$PREFIX/share/Kvantum/Acid-Dark"
    _rm "$PREFIX/share/plasma/desktoptheme/Acid-Dark"
    _rm "$PREFIX/share/plasma/look-and-feel/org.kde.acid-dark"
    _rm "$PREFIX/share/wallpapers/Acid-Dark"
    _rm "$PREFIX/share/sddm/themes/Acid-Dark"
}

_install() {
    _msg "Installing ..."
    sudo cp -R \
        "./aurorae" \
        "./color-schemes" \
        "./Kvantum" \
        "./plasma" \
        "./wallpapers" \
        "./sddm" \
        "$PREFIX/share"
}

_cleanup() {
    _msg "Clearing cache ..."
    rm -rf "$temp_file" "$temp_dir" \
        ~/.cache/plasma-svgelements-Acid-Dark* \
        ~/.cache/plasma_theme_Acid-Dark*.kcache
    _msg "Done!"
}

trap _cleanup EXIT HUP INT TERM

temp_file="$(mktemp -u)"
temp_dir="$(mktemp -d)"

if [ "$uninstall" = "false" ]; then
    _uninstall
    _install
else
    _uninstall
fi
 
