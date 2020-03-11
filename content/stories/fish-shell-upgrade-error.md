---
title: "Fish Shell Upgrade Error"
date: 2020-02-29T10:12:40+07:00
draft: false
tags: ["fish shell", "elementary os"]
disqus: true
---

Fish shell gagal di upgrade karena issue https://github.com/fish-shell/fish-shell/issues/5822. Package manager gagal me-replace file autocompletion rg.fish. 

Penyebabnya adalah, pernah instalasi aplikasi ripgrep menggunakan cargo. Cargo adalah package manager bawaan dari bahasa pemograman rust. 

Cargo menjadikan user rigprep sebagai pemilik file rg.fish. Sehingga package manager bawaan OS gagal me-replace file tersebut.

Efek errornya, saya tidak bisa masuk ke terminal. Masuk console melalui shortcut Ctrl-Alt-F1 pun tidak bisa.

Instalasi aplikasi baru juga tidak bisa. Masih tersangkut error gagal upgrade fish shell.

## Solusi

### Mengembalikan Terminal

Saya menggunakan aplikasi Dconf Editor[^1] untuk mengganti setelan opsi shell menjadi _bash_, yang defaultnya adalah _fish_[^2] untuk aplikasi terminal Elementary OS. 

[^1]: https://wiki.gnome.org/action/show/Projects/dconf?action=show&redirect=dconf

[^2]: Nilai defaultnya berasal dari perintah chsh pada user.

{{< figure src="/images/fish-shell-upgrade-error/dconf-editor.png" caption="Dconf Editor" alt="Dconf Editor" >}}

### Force Overwrite

Setelah berhasil masuk terminal, saya bisa memperbaiki proses upgrade fish shell yang gagal.

Perintah dibawah ini digunakan untuk memaksa manajer aplikasi untuk overwrite file jika diperlukan.

```bash
sudo apt -o Dpkg::Options::="--force-overwrite" -f upgrade
```

## Catatan

Saat terjadi masalah gagal upgrade fish shell saya langsung restart OS. Terminal tidak bisa dibuka setelah restart.

Padahal awalnya terminal masih bisa dibuka. Harusnya saat itu langsung diterapkan solusi force overwrite.

Jangan lupa untuk mengembalikan nilai shell menjadi default setelah berhasil. Cek **User default value** setelan opsi shell pada dconf-editor.
