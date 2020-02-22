---
title: "Membuat Website Gratis Github"
date: 2017-06-28T06:00:00+07:00
draft: false
tags: ["tutorial", "github"]
---

Membuat website sederhana yang menampilkan profil pribadi atau organisasi bisa 
dilakukan dengan menggunakan Github. Kita tidak perlu menyewa jasa penyedia hosting 
berbayar. Cukup dengan membuat akun Github fasilitas “hosting” web bisa digunakan 
secara gratis.

<!--more-->

Github bagi programmer pasti sudah sangat familiar. Penyedia jasa penyimpanan source 
code yang menggunakan aplikasi pengontrol versi git. Dengan git, aplikasi yang dibuat 
bisa dilacak perubahannya. Dan dengan adanya Github, aplikasi tidak hanya tersimpan 
dikomputer lokal saja, namun juga tersedia dicloud. Selain itu Github juga memberikan 
kemudahan bagi pengembang aplikasi untuk saling berkolaborasi.

Kita lanjut langkah demi langkah membuat website perdana menggunakan Github.

Jika belum memiliki akun Github, buat terlebih dahulu akunnya [disini](https://github.com). Nama akun yang dibuat, 
akan menjadi nama websitenya. Misalnya nama akun adalah hazulifidastian, nama 
websitenya akan menjadi hazulifidastian.github.io.

Jika akun sudah tersedia, login terlebih dahulu. Lanjutkan dengan membuat repository 
baru dengan nama hazulifidastian.github.io (nama repository sama dengan nama akun). 

Repository adalah tempat rekam perubahan source code akan disimpan. Misalnya Saya 
membuat aplikasi perpustakaan, kemudian saya membuat repository dengan nama 
perpustakaan. Rekam perubahan source code aplikasi perpustakaan Saya akan tersimpan 
didalam repository ini.

Karena sekarang kita akan membuat website, source code website 
yang akan tersimpan di repository ini. Untuk membuat repository baru, cari tombol 
New repository.

Lanjutkan dengan melakukan clone (duplikasi) repository baru dibuat ke repository 
dikomputer lokal. Sebelumnya install aplikasi git di komputer lokal. Jalankan 
Terminal atau Command line.

{{< highlight bash >}}
$ git clone https://github.com/hazulifidastian/hazulifidastian.github.io.git
$ cd hazulifidastian.github.io
$ touch index.html
$ echo "Halaman Website dengan Github" >> index.html
{{< /highlight >}}


Clone akan menduplikasi repository git pada Github ke komputer lokal. Perintah git 
clone akan menghasilkan folder hazulifidastian.github.io. Didalam folder tersebut, 
buat file index.html. Isikan dengan teks “Halaman Website dengan Github”.

Catatan, jika menggunakan OS Windows, perintah touch dan echo tidak bisa digunakan. 
Sebagai gantinya, gunakan aplikasi Notepad untuk membuat file index.html didalam 
folder tersebut.

Langkah selanjutnya, adalah menyimpan (merekam) perubahan pada repository git lokal, 
dan kemudian mengirimkan kembali ke Github.

{{< highlight bash >}}
$ git add -A
$ git commit -m "Initial commit"
{{< /highlight >}}

Perintah git add -A untuk memasukkan semua source code yang berubah. git commit untuk 
merekam perubahan, dengan pesan “Initial commit”.

Pesan bisa dirubah, misalnya “kode pertama web saya”. Sekarang kirimkan perubahan ke Github,

{{< highlight bash >}}
$ git push origin master
{{< /highlight >}}

Git akan meminta username dan password Github.

Jika proses pengiriman selesai, buka halaman web hazulifidastian.github.io. Akan terlihat teks, “Halaman Website 
dengan Github”.

Tutorial lanjutan adalah menggunakan custom domain website Github.
