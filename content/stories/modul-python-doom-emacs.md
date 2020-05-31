---
title: "Modul Python Doom Emacs"
date: 2020-05-29T04:37:06+07:00
draft: true
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

Ketikkan perintah `~/.emacs.d/bin/doom sync` untuk menyesuaikan perubahan pada konfigurasi pada doom emacs.
