---
title: "Magit Cheatsheet"
date: 2020-06-15T20:39:51+07:00
draft: false
toc: true
tags: ["emacs", "magit"]
disqus: true
description: Emacs magit cheatsheet. Artikel ini akan selalu diperbarui.
---

Saya menggunakan Emacs 27, dengan framework konfigurasi Doom. Standarnya, Doom menggunakan emulasi vim menggunakan evil-mode.
Jadi cheatsheet yang ada pada artikel ini, terutama shortcut magit-nya tidak akan terlepas dari evil-mode.

Bagi Anda vanilla user, saya memasukkan nama command/perintah untuk melengkapi shortcut key. Agar, jika Anda tidak mengenali key-nya, Anda bisa mengakses perintahnya melalui shortcut `M-x`.

## Shortcut

### Magit Buffer

|         Key         | Command &/ Deskripsi                                                                    |
| :-----------------: | :-------------------------------------------------------------------------------------- |
|      `SPC gg`       | **`magit-status`**. Buka buffer magit (git status)                                      |
|        `gr`         | Refresh buffer magit                                                                    |
|         `?`         | Popup perintah-perintah magit                                                           |
|    **Navigasi**     |                                                                                         |
| `j` `k` `Up` `Down` | Pindah antar baris                                                                      |
|     `M-n` `M-p`     | Pindah antar section                                                                    |
|    `TAB` `S-TAB`    | Toggle visibility, detail section / baris                                               |
|      **Diff**       |                                                                                         |
|         `D`         | **`magit-diff`** Menu diff                                                              |
|        `Dt`         | **`magit-diff-toggle-refine-hunk`**, highlight perubahan agar mudah dilihat.            |
|         `V`         | **`evil-visual-line`**. Memulai seleksi pada hunk.                                      |
|         `v`         | **`evil-visual-char`**. Memulai seleksi pada hunk.                                      |
|      `C-c C-t`      | **`magit-diff-trace-definition`**. Tampilkan history perubahan dari fungsi/variabel/etc |
|         `-`         | **`magit-reverse`**. Reverse staged hunk                                                |
|     **Discard**     |                                                                                         |
|         `d`         | **`magit-discard`**. Hapus perubahan pada sebuah poin.                                  |
|       **Log**       |                                                                                         |
|         `l`         | **`magit-log`**. Menu log                                                               |
|        `ll`         | **`magit-log-current`**. Current branch log                                             |
|     **Commit**      |                                                                                         |
|         `c`         | **`magit-commit`**. Menu commit                                                         |
|        `ce`         | **`magit-commit-extends`**. Extends commit, tanpa mengganti pesan commit                |
|        `cw`         | **`magit-commit-reword`**. Reword commit, ganti pesan commit                            |
|        `ca`         | **`magit-commit-amend`**. Amend commit                                                  |
|        `cf`         | **`magit-commit-fixup`**. Fixup commit                                                  |
|        `cs`         | **`magit-commit-squash`**. Squash commit                                                |
|      `C-c C-c`      | Save commit                                                                             |
|      `C-c C-k`      | Cancel commit                                                                           |
|     `M-n` `M-p`     | Pilih history pesan, saat mengetik pesan commit                                         |
|     **Branch**      |                                                                                         |
|         `b`         | **`magit-branch`**. Menu branch                                                         |
|        `bb`         | Daftar branch                                                                           |
|        `bl`         | Daftar branch lokal saja                                                                |
|        `bc`         | Buat branch baru dan checkout                                                           |
|        `bn`         | Buat branch baru tanpa checkout                                                         |
|        `bs`         | **`magit-branch-spinoff`**. Spinoff new branch                                          |
|     **Revert**      |                                                                                         |
|         `_`         | **`magit-revert`**. Menu revert                                                         |
|        `_O`         | **`magit-revert-and-commit`**. Revert dan commit                                        |
|        `_o`         | **`magit-revert-no-commit`** Revert tanpa commit                                        |
|      **Reset**      |                                                                                         |
|         `O`         | **`magit-reset`**. Menu reset                                                           |
|      **Stash**      |                                                                                         |
|         `Z`         | **`magit-stash`**. Menu stash                                                           |
|        `Zi`         | **`magit-stash-index`**. Stash index                                                    |
|        `Zz`         | **`magit-stash-both`**. Stash index dan untracked file                                  |
|        `Zp`         | **`magit-stash-pop`**. Pop stash, hapus dari daftar stash dan kembalikan ke index       |
|                     | **Daftar stash**                                                                        |
|         `a`         | Apply, kembalikan stash pilihan ke index                                                |
|     **Rebase**      |                                                                                         |
|         `r`         | **`magit-rebase`**. Menu rebase                                                         |
|                     | **Daftar commit**                                                                       |
|        `ri`         | **`magit-rebase-interactive`**. Rebase interaktif                                       |
|                     | **Daftar commit pilihan saat rebase interaktif**                                        |
|         `p`         | pickup - Ambil commit                                                                   |
|         `r`         | reword - Ambil commit, tapi lakukan perubahan pesan                                     |
|         `e`         | edit - Ambil commit, tapi lakukan perubahan commit                                      |
|         `s`         | squash - Ambil commit, tapi gabungkan dengan commit sebelumnya                          |
|         `f`         | fixup - Ambil commit, gabungkan dengan commit sebelumnya dan hapus pesan                |
|         `d`         | drop - Hapus commit                                                                     |
|         `u`         | undo - Batalkan perubahan terakhir                                                      |
|      `C-c C-c`      | Simpan                                                                                  |
|      `C-c C-k`      | Batalkan                                                                                |
|       `j` `k`       | Pindah baris                                                                            |
|      `gj` `gk`      | Pindahkan baris commit                                                                  |
|        `RET`        | Tampilkan commit dibuffer yang lain                                                     |
|    **Lain-lain**    |                                                                                         |
|         `$`         | Menampilkan history command yang dilakukan dimagit buffer                               |

Contoh kasus kenapa kita butuh `branch new spin-off`:

- Kita sedang ada dibranch master
- Sudah melakukan perubahan kode dan beberapa commit
- Commit dibranch master tersebut belum dipush ke upstream
- Dan, kita ingin memisahkan commit tersebut menjadi branch tersendiri

`branch new spin-off` akan melakukan:

- Memisahkan beberapa commit terakhir dibranch master menjadi branch tersendiri
  dengan mengambil patokan dari upstream, misal origin/master
- Mengembalikan/mereset branch master sesuai dengan commit terakhir diupstream, origin/master
- Checkout otomatis ke branch baru

### File Buffer

|    Key    | Command &/ Deskripsi                                                         |
| :-------: | :--------------------------------------------------------------------------- |
| `C-c M-g` | **`magit-file-dispatch`**. Menu magit yang bisa diterapkan pada buffer aktif |
| `SPC g /` | **`magit-dispatch`**. Menu global magit, tanpa perlu membuka buffer magit    |
| `SPC g L` | **`magit-log`**. Menu magit log pada buffer aktif                            |

## Referensi

- EmacsConf 2019 Magit deep dive - Jonathan Chu https://www.youtube.com/watch?v=vS7YNdl64gY
- https://magit.vc/manual/magit/Branch-Commands.html
- https://fluca1978.github.io/2017/06/11/magit-spin-offs-anothew-way-to-name.html
- http://blog.jenkster.com/2017/07/emacs-feature-branch-tip.html
