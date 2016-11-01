pkg_origin=jessicadevita
pkg_name=gogs
pkg_version=0.9.97
pkg_maintainer='Jessica DeVita <jessica@chef.io>'
pkg_license=('Apache-2.0')
pkg_source=https://dl.gogs.io/gogs_v0.9.97_linux_amd64.zip
pkg_shasum=4a5ae7f828e02504e1589b9ae0965d3809910ae35331a10e8396130761f2181b
pkg_deps=(core/busybox-static core/glibc core/linux-pam)
pkg_svc_user=root
pkg_svc_run="gogs web"
pkg_expose=(3000)
#pkg_build_deps=(core/jdk8)
pkg_bin_dirs=(bin)
pkg_include_dirs=(include)
pkg_lib_dirs=(lib)
pkg_dirname=gogs
do_build() {
  return 0
}
do_install() {
  install -D -v gogs $pkg_prefix/bin/gogs
  cgo_wrap_binary gogs
  cp -rv public scripts templates $pkg_prefix/bin/
}

cgo_wrap_binary() {
  local bin="$pkg_prefix/bin/$1"
  build_line "Adding wrapper $bin to ${bin}.real"
  mv -v "$bin" "${bin}.real"
  cat <<EOF > "$bin"
#!$(pkg_path_for busybox-static)/bin/sh
set -e
export LD_LIBRARY_PATH="$LD_RUN_PATH"
exec $(pkg_path_for glibc)/lib/ld-linux-x86-64.so.2 ${bin}.real \$@
EOF
  chmod -v 755 "$bin"
}
