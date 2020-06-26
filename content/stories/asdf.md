---
title: "asdf"
date: 2020-06-26T10:24:41+07:00
draft: true
toc: true
tags: ["asdf"]
description: "TODO"
---

`asdf` adalah command line interface (CLI) yang digunakan untuk
memanajemeni beberapa atau banyak versi bahasa pemrograman. `asdf`
seperti `pyenv` pada python, `rbenv` pada ruby atau `nvm` pada
nodejs tetapi all in one. `asdf` bisa menangani semuanya, khususnya
bahasa pemrograman populer.

Pada perkembangan, `asdf` tidak hanya digunakan untuk bahasa
pemgrograman saja. Ada plugin yang bisa memanajemeni
database seperti mysql dan postgresql, redis, bahkan text editor neovim.

## Kenapa asdf?

Menurut dokumentasi resminya, ini adalah alasan kenapa menggunakan `asdf`:

- Cukup satu command line interface (CLI) untuk memanajemeni banyak bahasa pemrograman
- Perintahnya konsisten untuk semua bahasa
- Satu konfigurasi global untuk semua bahasa
- Satu file konfigurasi untuk setiap project .tool-versions`
- Untuk kemudahan migrasi, mendukung file konfigurasi `.node-version`,
  `.nvmrc`, `.ruby-version` for easy migration
- Otomatis berganti versi saat pindah direktori
- Shell completion, tersedia untuk Bash, Zsh dan Fish

## Pemasangan asdf

Saya hanya akan menuliskan cara pemasangan menggunakan Linux Elementary OS atau Ubuntu.
Untuk sistem operasi lain silahkan baca di tautan [Install asdf](https://asdf-vm.com/#/core-manage-asdf-vm?id=install) ini.

**Dependensi**

`asdf` bergantung pada aplikasi `git` dan `curl`.

```bash
apt install git curl
```

**Memasang asdf**

```bash
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
cd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"
```

Baris pertama perintah diatas, meng-cloning repositori `asdf` dari github
ke direktori `~/.asdf`. Baris keduanya digunakan untuk
pindah ke direktori `~/.asdf`.

Pada perintah ketiga, git akan melakukan checkout ke versi terakhir `asdf`
yang definisikan oleh tag pada repositori git.

**Integrasi dengan shell**

Tambahkan baris dibawah ini ke `~/.bashrc`.

```bash
. $HOME/.asdf/asdf.sh
```

Tambahkan juga baris dibawah ini untuk **completions** `~/.bashrc`.

```bash
. $HOME/.asdf/completions/asdf.bash
```

Dengan diaktifkannya **completions**, shell akan memberikan saran
opsi untuk melengkapi perintah `asdf`.

Anda bisa merujuk [referensi](https://asdf-vm.com/#/core-manage-asdf-vm?id=add-to-your-shell) cara
pemasangan sesuai dengan shel yang anda pakai. Tersedia untuk shell bash, zsh dan fish.

## Plugins

Plugins adalah cara `asdf` memahami bagaimana menangani paket yang berbeda.
Misalnya plugin [python](https://github.com/danhper/asdf-python), berisi
script atau instruksi untuk menangani paket python.

### Daftar Plugin

Perintah dibawah digunakan untuk menampilkan daftar plugin yang tersedia.

```bash
asdf plugins list all

# daftar sebagian plugin
python         *https://github.com/danhper/asdf-python.git
R              https://github.com/iroddis/asdf-R.git
ruby           *https://github.com/asdf-vm/asdf-ruby.git
```

Tambahkan perintah `grep` untuk menyaring daftar.

```bash
asdf plugins list all | grep elixir

# hasil penyaringan
elixir         *https://github.com/asdf-vm/asdf-elixir.git
```

### Memasang Plugin

Plugin bisa dipasang sesuai dengan nama yang ditampilkan oleh perintah `list all` diatas.
Perintah dibawah akan memasang plugin python.

```bash
asdf plugin add python
```

### Mencopot Plugin

Plugin yang sudah dipasang bisa dicopot jika tidak digunakan lagi. Perintah dibawah mencopot
pemasangan plugin.

```bash
asdf plugin remove python
```

### Memperbarui Plugin

Plugin sebenarnya adalah script atau instruksi untuk memanajemeni paket. Script ini merupakan repository yang tersimpan di github.
Yang saya pahami, instruksi ini biasanya berupa shell script (bash script). Lakukan pembaruan secara berkala untuk
memastikan keandalannya.

```bash
asdf plugin update python
```

Diatas adalah perintah untuk memperbarui plugin python. Untuk memperbarui seluruh plugin, gunakan
perintah.

```bash
asdf plugin update --all
```

## asdf dan Python

Pada bagian ini saya akan menjelaskan alur kerja penggunaan plugin `asdf` yaitu python. Mulai dari pemasangan
plugin, hingga menerapkan versi tertentu pada project.

### Memasang Plugin Python

Dibawah adalah perintah pemasangan plugin python. Perintah tersebut akan mengunduh script
yang berfungsi untuk memanajemeni paket python.

```bash
asdf plugin add python
```

`asdf` bergantung dengan plugin, perintah `asdf` seperti `asdf add <nama-plugin> <versi>` akan
menjalankan script plugin python untuk melakukan pemasangan. Begitu juga untuk plugin yang lain,
`asdf` akan menjalankan script plugin tersebut.

Lihat repository plugin python [di github](https://github.com/danhper/asdf-python/tree/master/bin) ini.
File-filenya berisi shell script (bash) untuk menangani perintah seperti `install` juga `list-all`.

### Melihat Daftar Paket Python

Setelah pemasangan, perintah dibawah digunakan untuk menampilkan daftar paket python yang tersedia.

```bash
asdf list all python

# Sebagian daftar paket python
3.7.7
3.8.3
anaconda3-5.3.1
ironpython-2.7.7
jython-dev
jython-2.5.0
jython-2.7.1
miniconda3-4.7.12
pypy3.6-7.3.1
```

Akan muncul banyak paket python. Gunakan perintah tambahan `grep` untuk menyaring daftar paket.

```bash
asdf list all python | grep miniconda

# Sebagian hasil
miniconda3-4.5.12
miniconda3-4.6.14
miniconda3-4.7.10
miniconda3-4.7.1
```

### Memasang Versi Python

Paket versi berapa yang harus dipasang?

Itu tergantung dengan kebutuhan Anda, contoh.

- Ingin bereksperimen dengan python versi terbaru
- Atau ingin bereksperimen dengan versi yang sedang dikembangkan (dev).
  Saring daftar paket dengan `grep dev`
- Ingin melakukan pengetesan kompatibilitas aplikasi atau project terhadap beberapa versi python

Saya sendiri akan memasang python versi 3.7 dan python 3.8. Saat ini, versi 3.7.7 adalah versi terakhir dari python 3.7.
Sedangkan versi 3.8.3 adalah versi terakhir dari python 3.8.

```bash
asdf install python 3.7.7
asdf install python 3.8.3
```

Uppss.. Error.

`asdf` memasang paket python menggunakan metode kompilasi source code. `asdf` tidak mengunduh paket binary python,
namun source codenya.

Sebelum melakukan kompilasi, perlu dipenuhi dependensi yang dibutuhkan oleh source code python.

Pada sistem operasi elementary os atau ubuntu, ketik perintah[^1].

[^1]: https://github.com/pyenv/pyenv/wiki/Common-build-problems

```bash
sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python-openssl
```

Ulang kembali perintah pemasangan python 3.7.7 dan 3.8.3 diatas.

### Set Versi Global

Sekarang saya memiliki dua versi python dalam satu perangkat komputer, bagaimana
cara saya menggunakannya.

`asdf` memiliki fitur untuk mengeset satu versi dari paket menjadi global. Hanya satu versi
yang bisa global dari sebuah paket menjadi global.

Jika kita menjalankan perintah dibawah ini.

```bash
asdf global python 3.7.7
```

Python 3.7.7 sekarang menjadi versi global. Artinya, dari manapun Anda menjalankan python,
otomatis akan menggunakan python versi global.

```bash
cd ~
python --version
# hasilnya
Python 3.7.7

cd /usr/local
python --version
# hasilnya
Python 3.7.7

which python
# hasilnya
/home/username/.asdf/shims/python
```

### pip

`pip` otomatis terpasang berbarengan dengan pemasangan python. Anda bisa melakukan pemasangan paket python
menggunakan `pip`. Paket python disini diluar konteks `asdf`, karena pip merupakan manajer khusus paket python.

Biasanya, pemasangan paket global `pip` bisa menggunakan opsi `--user` atau `--global`. `pip` akan memasang paket
agar bisa diakses secara global. Python `asdf` juga bisa memakai opsi itu. Tetapi, saya lebih suka paket terikat
dengan versi pythonnya, tidak dengan user atau sistem operasi.

Karena python 3.7.7 sudah di set global oleh `asdf`, maka `pip` juga akan mengarah ke python tersebut. Otomatis juga
paket-paket yang dipasang menggunakan `pip`.

Contohnya saya memasang paket `black`, `pylint` dan `flake8`.

```bash
pip install -U black
pip install -U pylint
pip install -U flake8

asdf reshim python

which black
which pylint
which flake8

# hasilnya
/home/username/.asdf/shims/black
/home/username/.asdf/shims/pylint
/home/username/.asdf/shims/flake8
```

Terlihat paket yang dipasang berada didalam direktori asdf. Dan paket tersebut bisa diakses dari lokasi manapun.

### reshim

Setelah pemasangan paket menggunakan pip, selalu jalankan perintah `reshim`.

```bash
asdf reshim python 3.7.7
```

Ini memastikan paket yang baru dipasang (jika paket tersebut memiliki file executable) bisa diakses.

Perhatikan hasil perintah `which black` dibawah ini. `black` adalah paket python yang memiliki file executable dengan nama `black` juga.

```bash
which black

# hasilnya
/home/username/.asdf/shims/black
```

Jika dilihat file `shims/black`,

```bash
cat /home/username/.asdf/shims/black
```

berisi intersepsi dan pengalihan perintah ke `asdf`. `asdf` nantinya akan memilihkan versi `black` yang tepat.

```bash
#!/usr/bin/env bash
# asdf-plugin: python 3.7.7
exec /home/username/.asdf/bin/asdf exec "black" "$@"
```

Apa itu shim? Menurut wikipedia[^2], shim adalah:

[^2]: https://en.wikipedia.org/wiki/Shim_(computing)

> In computer programming, a shim is a library that transparently intercepts API calls
> and changes the arguments passed, handles the operation itself or
> redirects the operation elsewhere.

Kata kuncinya:

- Intersepsi pemanggilan API
- Mengganti argument-argumentnya
- Menangani sendiri operasi, atau mengalihkannya ke tempat lain

Referensi lebih lengkap untuk memahami shim, silahkan baca artikel yang menjelaskan cara kerja pyenv ini[^3].
Atau baca langsung penjelasan dari dokumentasi[^4] `asdf`.

[^3]: https://mungingdata.com/python/how-pyenv-works-shims/
[^4]: https://asdf-vm.com/#/core-manage-versions?id=shims

### Set Versi Lokal Per Project

`asdf` menyediakan fitur untuk mendefinisikan versi yang berbeda dengan versi global, pada sebuah direktori.
Hal ini sangat berguna, seperti saat menggunakan tool dependensi manajemen seperti `poetry` dan `pipenv`.

Perintah dibawah ini akan membuat direktori project, dan menjadikan python versi 3.8.8 sebagai versi standarnya.

```bash
mkdir project_python_38
cd project_python_38
asdf local python 3.8.3

# cek versi python
python --version

# hasilnya
Python 3.8.3
```

Di direktori tersebut, `asdf` membuat file `.tool-versions` berisi,

```bash
python 3.8.3
```

Jika project tidak hanya menggunakan python, misalnya juga menggunakan nodejs. Gunakan perintah untuk menerapkan versi
lokal nodejs di direktori tersebut. Namun, pastikan plugin nodejs dan paketnya sudah terpasang.

```bash
asdf local nodejs 12.16.3
```

File `.tool-versions` akan berisi informasi tambahan berupa versi lokal nodejs.

```bash
python 3.8.3
nodejs 12.16.3
```

## Plugin Lainnya

### PHP

### Erlang

### Elixir

### Ruby

### PostgreSql

## Cheatsheet

Berikut daftar opsi yang bisa digunakan pada perintah `asdf`.

**Manajemen plugin**

|                             |                                                    |
| :-------------------------- | :------------------------------------------------- |
| `asdf list`                 | daftar plugin beserta versi yang terpasang         |
| `asdf plugin list all`      | daftar seluruh plugin                              |
| `asdf plugin list`          | daftar plugin yang terpasang di perangkat personal |
| `asdf plugin list --urls`   | daftar plugin yang terpasang beserta urlnya        |
| `asdf plugin add python`    | pasang plugin python                               |
| `asdf plugin remove python` | copot plugin python                                |
| `asdf plugin update python` | perbarui plugin python                             |
| `asdf plugin update --all`  | perbarui seluruh plugin                            |

**Manajemen paket**

|                                  |                                         |
| :------------------------------- | :-------------------------------------- |
| `asdf list all python`           | daftar versi python yang bisa dipasang  |
| `asdf latest python`             | versi stabil terakhir python            |
| `asdf latest python` 3.8         | versi stabil terakhir python 3.8        |
| `asdf install python 3.7.7`      | pasang python versi 3.7.7               |
| `asdf install python 3.8.3`      | pasang python versi 3.8.3               |
| `asdf install latest python`     | pasang python versi stabil terakhir     |
| `asdf install latest python 3.8` | pasang versi stabil terakhir python 3.8 |
| `asdf uninstall python 3.7.7`    | copot python versi 3.7.7                |
| `asdf uninstall python 3.8.3`    | copot python versi 3.8.3                |
| `asdf list python`               | daftar versi python yang terpasang      |

**Utilitas**

|                            |                                        |
| :------------------------- | :------------------------------------- |
| `asdf global python 3.7.7` | menjadikan python 3.7.7 global runtime |
| `asdf current`             | daftar plugin beserta versi globalnya  |
| `asdf reshim python 3.7.7` | Re-create shim                         |
| `asdf update`              | perbarui asdf ke versi stabil terakhir |

`python` pada tabel diatas adalah nama plugin, bisa dirubah menyesuaikan plugin masing-masing.

## Kesimpulan

```

```

```

```
