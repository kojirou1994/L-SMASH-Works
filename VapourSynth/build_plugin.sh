#!/bin/bash

deps_dir=$PWD/deps

set -e

git clone https://github.com/HomeOfAviSynthPlusEvolution/FFmpeg -b custom-patches-for-lsmashsource --depth 1
git clone https://github.com/vimeo/l-smash.git --depth 1
git clone https://github.com/dwbuiten/obuparse.git --depth 1

cd obuparse
make -j$(nproc)
sudo make install-static
cd ..

cd l-smash
./configure --extra-cflags=-fPIC
make -j$(nproc)
sudo make install
cd ..


cd FFmpeg
./configure --prefix=$deps_dir --enable-gpl --enable-version3 --enable-nonfree --enable-static --disable-shared --enable-pic --disable-autodetect --disable-doc --disable-programs
make -j$(nproc)
make install
cd ..


mkdir vs_build
cd vs_build
export PKG_CONFIG_PATH=$deps_dir/lib/pkgconfig/:/home/linuxbrew/.linuxbrew/opt/vapoursynth/lib/pkgconfig/:/home/linuxbrew/.linuxbrew/opt/zimg/lib/pkgconfig/
export LDFLAGS="-Wl,-Bsymbolic"
meson
ninja
strip libvslsmashsource.so
