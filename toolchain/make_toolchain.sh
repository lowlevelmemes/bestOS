#! /bin/sh

set -ex

srcdir="$(dirname "$0")"
test -z "$srcdir" && srcdir=.
srcdir="$(cd "${srcdir}" && pwd -P)"

cd "$srcdir"

if command -v gmake; then
    export MAKE=gmake
else
    export MAKE=make
fi

if [ -z "$CFLAGS" ]; then
    export CFLAGS="-O2 -pipe"
fi

PREFIX="$(pwd -P)"
TARGET=ia16-elf

export MAKEFLAGS="-j$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || psrinfo -tc 2>/dev/null || echo 1)"

export PATH="$PREFIX/bin:$PATH"

which gcc
rm -f "$PREFIX/bin/gcc"
ORIG_GCC="$(which gcc)"
cat <<EOF >"$PREFIX/bin/gcc"
#! /bin/sh
"$ORIG_GCC" "\$@" -Wno-error=implicit-function-declaration
EOF
chmod +x "$PREFIX/bin/gcc"

which g++
rm -f "$PREFIX/bin/g++"
ORIG_GXX="$(which g++)"
cat <<EOF >"$PREFIX/bin/g++"
#! /bin/sh
"$ORIG_GXX" "\$@" -Wno-error=implicit-function-declaration
EOF
chmod +x "$PREFIX/bin/g++"

git clone https://codeberg.org/tkchia/binutils-ia16.git --depth=1 || true
git -C binutils-ia16 pull
git clone https://codeberg.org/tkchia/gcc-ia16.git --depth=1 || true
git -C gcc-ia16 pull

rm -rf build
mkdir build
cd build

mkdir build-binutils
cd build-binutils
../../binutils-ia16/configure CFLAGS="$CFLAGS" CXXFLAGS="$CFLAGS" --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
$MAKE all-binutils all-ld all-gas
$MAKE install-binutils install-ld install-gas
cd ..

cd ../gcc-ia16
[ -f mpfr-2.4.2.tar.bz2 ] || ./contrib/download_prerequisites
cd ../build
mkdir build-gcc
cd build-gcc
../../gcc-ia16/configure CFLAGS="$CFLAGS" CXXFLAGS="$CFLAGS" --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c --without-headers --disable-multilib
$MAKE all-gcc
$MAKE all-target-libgcc
$MAKE install-gcc
$MAKE install-target-libgcc
cd ..
