---
title: "PHP Notes"
date: 2022-02-22T23:32:19+07:00
draft: false
disquss: true
description: "Catatan-catatan kecil seputar PHP"
tags: ["php"]
---

## Tools

### Xdebug Mode Off Trigger Makefile Error

Pesan error:

```bash
make: *** [Makefile:135: dump-autoload] Error 2816
```

Solusi:

1. Hilangkan setting `XDEBUG_MODE = "off"`
2. Tambahkan informasi folder composer pada konfigurasi _skipped paths_ di PHPStorm. Lihat tautan ini https://github.com/composer/composer/issues/8302#issuecomment-526908909.
