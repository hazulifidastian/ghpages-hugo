---
title: "Compiling Emacs 27 Ubuntu 18.04"
date: 2020-05-30T16:26:37+07:00
draft: false
tags: ["emacs", "elementary os"]
disqus: true
---

Proses kompilasi emacs tidak terlalu sulit, hanya perlu mempersiapkan
instalasi beberapa tools dan library.

**Compile & Install**

```bash
# Jika OS sudah terinstalasi emacs26, sebaiknya diuninstall terlebih dahulu
sudo apt purge emacs26 emacs26-common

# Install tools dan library
sudo apt install build-essential libx11-dev libxpm-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev libncurses-dev libxpm-dev automake autoconf libgtk-3-dev texinfo

# Download source code emacs
wget https://github.com/emacs-mirror/emacs/archive/emacs-27.0.91.tar.gz

tar -xzf emacs-27.0.91.tar.gz

# Konfigurasi dan install emacs
cd emacs-27.0.91
./autogen.sh
./configure
make
make install

# Check instalasi
emacs --version
```

**Rebuild**

Setelah instalasi selesai, file konfigurasi emacs perlu di **build**
ulang menggunakan emacs versi terbaru. Saya menggunakan doom
emacs, perintahnya:

```bash
~/.emacs.d/bin/doom sync
~/.emacs.d/bin/doom build
```

Jika tidak di **rebuild** ulang, emacs akan menampilkan interface standard.
Hasil kompilasi konfigurasi menggunakan Emacs 26 tidak bisa digunakan pada Emacs 27.

**Uninstall**

Jika ingin menhapus instalasi, ketik perintah:

```bash
make uninstall
```
