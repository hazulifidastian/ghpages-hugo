---
title: "asdf Cheatsheet"
date: 2020-06-27T05:29:47+07:00
draft: false
tags: ["asdf"]
---

## Cheatsheet

Berikut daftar opsi yang bisa digunakan pada perintah `asdf`.

### Manajemen Plugin

<table>
  <thead>
    <tr>
      <th style="width:55%" align="left">Perintah</th>
      <th align="left">Deskripsi</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td align="left"><code>asdf list</code></td>
        <td align="left">daftar plugin beserta semua paket yang terpasang</td>
    </tr>
    <tr>
        <td align="left"><code>asdf plugin list all</code></td>
        <td align="left">daftar seluruh plugin</td>
    </tr>
    <tr>
        <td align="left"><code>asdf plugin list</code></td>
        <td align="left">daftar plugin yang terpasang</td>
    </tr>
    <tr>
        <td align="left"><code>asdf plugin list --urls</code></td>
        <td align="left">daftar plugin yang terpasang beserta urlnya</td>
    </tr>
    <tr>
        <td align="left"><code>asdf plugin add python</code></td>
        <td align="left">pasang plugin python</td>
    </tr>
    <tr>
        <td align="left"><code>asdf plugin remove python</code></td>
        <td align="left">copot plugin python</td>
    </tr>
    <tr>
        <td align="left"><code>asdf plugin update python</code></td>
        <td align="left">perbarui plugin python</td>
    </tr>
    <tr>
        <td align="left"><code>asdf plugin update --all</code></td>
        <td align="left">perbarui seluruh plugin</td>
    </tr>
  </tbody>
</table>

### Manajemen Paket

<table>
  <thead>
    <tr>
      <th style="width:55%" align="left">Perintah</th>
      <th align="left">Deskripsi</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td align="left"><code>asdf list all python</code></td>
        <td align="left">daftar paket python yang bisa dipasang</td>
    </tr>
    <tr>
        <td align="left"><code>asdf latest python</code></td>
        <td align="left">versi stabil terakhir paket python</td>
    </tr>
    <tr>
        <td align="left"><code>asdf latest python</code> 3.8</td>
        <td align="left">versi stabil terakhir paket python 3.8</td>
    </tr>
    <tr>
        <td align="left"><code>asdf install python 3.7.7</code></td>
        <td align="left">pasang paket python versi 3.7.7</td>
    </tr>
    <tr>
        <td align="left"><code>asdf install python 3.8.3</code></td>
        <td align="left">pasang paket python versi 3.8.3</td>
    </tr>
    <tr>
        <td align="left"><code>asdf install latest python</code></td>
        <td align="left">pasang paket python versi stabil terakhir</td>
    </tr>
    <tr>
        <td align="left"><code>asdf install latest python 3.8</code></td>
        <td align="left">pasang versi stabil terakhir dari paket python 3.8</td>
    </tr>
    <tr>
        <td align="left"><code>asdf uninstall python 3.7.7</code></td>
        <td align="left">copot paket python versi 3.7.7</td>
    </tr>
    <tr>
        <td align="left"><code>asdf uninstall python 3.8.3</code></td>
        <td align="left">copot paket python versi 3.8.3</td>
    </tr>
    <tr>
        <td align="left"><code>asdf list python</code></td>
        <td align="left">daftar paket python yang terpasang</td>
    </tr>
  </tbody>
</table>

### Utilitas

<table>
  <thead>
    <tr>
      <th style="width:55%" align="left">Perintah</th>
      <th align="left">Deskripsi</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td align="left"><code>asdf global python 3.7.7</code></td>
        <td align="left">set python 3.7.7 sebagai global runtime</td>
    </tr>
    <tr>
        <td align="left"><code>asdf current</code></td>
        <td align="left">daftar plugin beserta versi globalnya</td>
    </tr>
    <tr>
        <td align="left"><code>asdf reshim python 3.7.7</code></td>
        <td align="left">Re-create shim paket python 3.7.7</td>
    </tr>
    <tr>
        <td align="left"><code>asdf update</code></td>
        <td align="left">perbarui asdf ke versi terakhir yang stabil</td>
    </tr>
  </tbody>
</table>

`python` pada tabel diatas adalah nama plugin, bisa disesuaikan dengan nama plugin yang lain.
