---
title: "Halo Pelican"
date: 2019-07-14T03:32:00+07:00
draft: false
tags: ["pelican"]
---

Website ini sebelumnya dibuat menggunakan pure html dan framework css skeleton. Fiturnya hanya berisi informasi personal statis dan jarang diperbarui.

<!--more-->

Bosan dengan tampilan lama, style-nya akan saya perbarui dan konten-nya juga akan dibuat dinamis dengan menambahkan fitur blog.

{{< figure src="/images/halo-pelican/web.png" caption="Web dengan pelican" alt="Web" >}}

Perlu diketahui, untuk membuat konten dinamis diperlukan CMS (Content Management System). CMS yang umum dipakai (paling banyak) misalnya Wordpress, Joomla, Django, dll. Namun saya menghindari CMS yang harus diinstall diserver. Selain rawan keamanan jika tidak selalu diperbarui, juga butuh biaya tersendiri untuk sewa hosting.

Karena website ini konten-nya numpang gratis digithub, Cara paling mudah adalah memilih CMS yang bisa generate konten statis.

Pilihan jatuh ke [Pelican](https://blog.getpelican.com/) yang dibuat dengan [Python](https://www.python.org/).

Github sendiri menyediakan [Jekyll](https://help.github.com/en/articles/using-jekyll-as-a-static-site-generator-with-github-pages) sebagai generator konten statis-nya. Tapi saya nggak terlalu familiar dengan [Ruby](https://www.ruby-lang.org/en/). Selain itu [Golang](https://golang.org/) juga punya [Hugo](https://gohugo.io/) yang terkenal, dan mampu generate ribuan konten dalam hitungan detik. Namun lagi, saya juga kurang tertarik jika harus menggunakan _Golang_.

Pelican sangat mudah digunakan. Cara kerjanya:

1. Tulis konten dengan format reStructureText (.rst) atau Markdown (.md) di komputer lokal.
2. Dengan perintah sederhana diterminal[^1], Pelican akan men-generate file statis dalam format *.html*.
3. Output konten, yaitu folder berisi file-file html harus diunggah (dipublish) ke github.

Kemudian Github akan melayani request website kita dengan output konten yang diunggah tadi.

reStructureText adalah format pilihan. Biasanya saya membuat dokumentasi di *Sphinx* menggunakan format *.rst*. Selain itu lebih kaya fitur dibanding format *.md*.

Theme saya buat sendiri, idenya masih mengambil tampilan website yang lama. Framework css yang digunakan adalah [Miligram](https://milligram.io), sederhana dan ringan.

Membuat theme di Pelican ini sangat mudah, dokumentasinya cukup lengkap. Saya mengambil template standar *notmyidea* sebagai bootstrap.

Halaman dinamis tidak dinamai dengan blog, tetapi diberi nama Stori, mengambil ide fitur *stories* dari [Medium.com](https://medium.com>).

[^1]: Command line atau Command prompt
