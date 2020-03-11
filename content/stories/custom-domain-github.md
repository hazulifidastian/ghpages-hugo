---
title: "Custom Domain Github"
date: 2017-06-28T08:00:00+07:00
draft: false
tags: ["tutorial", "github"]
disqus: true
---

Setelah membuat website menggunakan Github, website bisa dibuatkan domain khusus. 
Artinya, setiap kita ingin akses ke website tidak perlu menggunakan domain standar 
bawaan dari Github hazulifidastian.github.io. Tapi bisa menggunakan alamat yang kita 
tentukan sendiri, misalnya alamat saya ini ~~hazulifidastian.my.id~~ hazulifidastian.id.

<!--more-->

Memiliki domain sendiri tidaklah terlalu sulit, hanya saja kita perlu membeli domain 
tersebut. Harganya pun tidak terlalu mahal, dibayarkan pertahun. Harganya antara 50 
ribu hingga 110 ribu untuk domain my.id, web.id, .com, .net dll.

## Konfigurasi repository di Github

Repository website kita pada Github harus dikonfigurasi agar bisa menerima custom 
domain. Buka repository website. Jika dari contoh post Saya sebelumnya, nama repository 
website adalah hazulifidastian.github.io.

{{< figure src="/images/custom-domain-github/github-settings-menu.png" caption="Github settings" alt="Github settigs" >}}

Pada halaman repository, dibawah nama repository hazulifidastian.github.io klik menu 
Settings. Menu dengan gambar gear.

{{< figure src="/images/custom-domain-github/github-custom-domain.png" caption="Github settings" alt="Github settigs" >}}

Cari Custom Domain, ganti dengan nama domain yang akan digunakan. Misalnya saya 
menggunakan domain ~~www.hazulifidastian.my.id~~ www.hazulifidastian.id. Setelah dirubah, simpan perubahan tersebut.

## Konfigurasi DNS

Login di client area tempat kita membeli domain, kemudian pilih domain yang akan 
dirubah konfigurasinya. Masing-masing penyedia jasa memiliki menu yang berbeda-beda. 
Temukan menu DNS Management.

{{< figure src="/images/custom-domain-github/dns-settings.png" caption="DNS Settings" alt="DNS Settings" >}}

Kita perlu menambahkan 3 record untuk mengarahkan domain kita ke Github. Hasil akhir 
semua record setelah ditambahkan bisa dilihat ditable dibawah ini.

|Domain|TTL|Class|Type|Destination|
|:--|:--:|:--:|:--:|:--:|
|www.hazulifidastian.id|14400|IN|CNAME|hazulifidastian.github.io|
|hazulifidastian.id|14400|IN|A|185.199.108.153|
|hazulifidastian.id|14400|IN|A|185.199.109.153|
|hazulifidastian.id|14400|IN|A|185.199.110.153|
|hazulifidastian.id|14400|IN|A|185.199.111.153|

Setelah penambahan, jika kita mengetikkan domain kita misalnya 
~~www.hazulifidastian.my.id~~ www.hazulifidastian.id halaman website kita belum akan muncul. Karena perubahan 
DNS membutuhkan waktu untuk setiap perubahan. Lamanya tergantung dengan provider 
domain, bisa beberapa menit bahkan bisa sampai sehari.
