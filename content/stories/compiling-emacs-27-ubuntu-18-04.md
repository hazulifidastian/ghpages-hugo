---
title: "Compiling Emacs 27 Ubuntu 18.04"
date: 2020-05-30T16:26:37+07:00
draft: false
tags: ["emacs", "ubuntu", "elementary os"]
---

Bagi yang ingin merasakan emacs versi  27, kita
mungkin akan kesulitan menemukan paketnya di Ubuntu 18.04.
Karena emacs versi 27 belum rilis versi stabilnya, juga 
versi ini masih dalam tahap beta.

Jika browsing [launchpad](https://launchpad.net/~kelleyk/+archive/ubuntu/emacs "launchpad") 
versi 27 juga belum ada. Terakhir masih versi 26.3.

Jika tidak ingin menunggu rilis, dan ingin buru-buru mencicipi 
emacs 27 ini kita bisa meng-compile sendiri.

Prosesnya tidak terlalu sulit, hanya perlu instalasi
beberapa tool dan librari. Kemudian kita download source code
Emacs 27 dari github, selanjutnya kita bisa compile dan instal.

```bash
# Jika sedang ada emacs26 sebaiknya diuninstall terlebih dahulu
sudo apt purge emacs26 emacs26-common

# Install tools dan library
sudo apt install build-essential libx11-dev libxpm-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev libncurses-dev libxpm-dev automake autoconf libgtk-3-dev texinfo

# Download source code emacs
wget https://github.com/emacs-mirror/emacs/archive/emacs-27.0.91.tar.gz

tar -xzf emacs-27.0.91.tar.gz

# Konfigurasi dan setup emacs
cd emacs-27.0.91
./configure
make
make install

# Check instalasi
emacs --version
```

Setelah instalasi selesai, file konfigurasi emacs perlu dibuild
ulang menggunakan emacs versi terbaru. Saya menggunakan doom
emacs, perintahnya:

```bash
~/.emacs.d/bin/doom sync
~/.emacs.d/bin/doom build
```

Jika tidak dibuild ulang, emacs akan menampilkan interface standard.
Konfigurasi themes dan lainnya yang kita gunakan dengan Emacs 26
tidak cocok dengan Emacs 27.

Jika ingin menhapus instalasi, ketik perintah:

```bash
make uninstall
```
