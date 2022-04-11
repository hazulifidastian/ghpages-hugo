---
title: "Python Notes"
date: 2022-04-11T07:36:02+07:00
draft: false
toc: true
disqus: true
description: "Catatan-catatan kecil seputar Python"
tags: ["python"]
---

## Tools

### Konversi requirements.txt ke Paket Poetry pyproject.toml

Dari **requirements.txt**:

```
pytest-django==4.5.2
```
di **pyproject.toml** menjadi

```toml
pytest-django = "4.5.2"
```

Menambahkan opsi dari  **requirements.txt**:

```
Werkzeug[watchdog]==2.0.3
```

di **pyproject.toml** menjadi

```toml
Werkzeug = {extras = ["watchdog"], version = "2.0.3"}
```