---
title: "Modul PHP Doom Emacs"
date: 2020-05-14T00:48:53+07:00
draft: false
tags: ["emacs", "php"]
disqus: true
---

## Konfigurasi Doom Emacs

### `init.el`

Jelajah file konfigurasi dengan shorcut `SPC f p`, kemudian pilih file `init.el`. Aktifkan beberapa modul dengan cara menghilangkan tanda komentar `;;`.

1. Modul `syntax`, ada pada grup `:checkers`.
2. Modul `lsp`, ada pada grup `:tools`.
3. Modul `(php +lsp)`, tambahan `+lsp`. Ada pada grup `:lang`.

### `package.el`

Aktifkan package phpactor pada file konfigurasi `package.el`. Buka dengan shorcut `SPC f p`.

```elisp
(package! phpactor)
```

### Sinkronisasi Konfigurasi Doom Emacs

Ketikkan perintah `~/.emacs.d/bin/doom sync` untuk menyesuaikan perubahan konfigurasi pada doom emacs.

## Install Phpactor

### Pastikan Ketersediaan PHP dan composer

Instalasi PHP dan composer sudah harus sudah tersedia sebelum melanjutkan ke langkah berikutnya. Instalasi PHP menyesuaikan dengan sistem operasi masing-masing.
Sedangkan instalasi composer bisa menggunakan panduan [berikut](https://getcomposer.org/doc/00-intro.md).

Gunakan Shortcut `M-x`, kemudian pilih perintah `phpactor-install-or-update`. Perintah ini akan mengunduh dan menginstalasi paket php `phpactor` menggunakan composer.

Hasil instalasi ada pada direktori `~/.emacs.d/phpactor`.

## Install Dependencies

Modul `php` emacs doom memiliki beberapa ketergantugan paket PHP. Paket tambahan tersebut diinstalasi secara global menggunakan composer.

```bash
composer global require \
    d11wtq/boris \
    phpunit/phpunit \
    techlivezheng/phpctags
```

### Konfigurasi variable environment PATH

Setelah instalasi selesai, composer meletakkan file executable pada folder `\~/.composer/vendor/bin`. Tergantung sistem operasi, lokasi file binary composer akan berbeda.

Pastikan lokasi file executable dari composer berada dalam variable `PATH`.

```bash
# place this in your profile file, like ~/.bash_profile or ~/.zshenv
export PATH="~/.composer/vendor/bin:$PATH"
```

Konfigurasi akan berbeda jika menggunakan `Fish shell`.

Dengan memasukkan folder executable composer ke variabel `PATH`, maka executable tersebut bisa diakses dari folder mana saja didalam sistem operasi.

### Sinkronisasi Konfigurasi Doom Emacs

Ketikkan perintah `~/.emacs.d/bin/doom sync` untuk menyesuaikan perubahan variabel environment dengan doom emacs.

## Instalasi LSP (Language Server Protocol) PHP

Intelephense adalah paket yang direkomendasikan oleh emacs-lsp untuk menjadi lsp PHP. Paket ini biasa digunakan sebagai ekstensi pada Visual Studio Code.

Instalasi intelephense menggunakan aplikasi npm.

```bash
sudo npm -i intelephense -g
```

## Tips

- Perintah phpactor bisa diakses menggunakan shortcut `M-x`, kemudian ketikkan `phpactor`. Anda bisa eksplorasi perintah-perintahnya. Mulai dari install atau update paket phpactor, hingga refactoring kode php.

## Troubleshooting

- Perintah `phpactor-...` tidak tersedia.
  Pastikan konfigurasi `(package! phpactor)` pada file `package.el` tertulis dengan benar.
- Pesan error, "LSP :: No LSP Server for php-mode".
  Pastikan Intelephense sudah diinstalasi dengan dengan akses global. Periksa dengan perintah `which intelephense` pada terminal.
- Selalu jalankan perintah `~/.emacs.d/bin/doom sync` setiap ada perubahan konfigurasi pada emacs.
