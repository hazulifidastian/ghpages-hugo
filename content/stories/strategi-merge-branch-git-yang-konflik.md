---
title: "Strategi Merge Branch Git yang Konflik"
date: 2021-08-26T21:06:01+07:00
draft: false
disqus: true
description: "Strategi paranoid untuk merge (menggabungkan) dua branch git yang konflik."
---

Saya termasuk orang yang paranoid saat melihat dua branch git yang akan digabungkan terdapat banyak konflik. Sudah terbayang kesulitan untuk memilih, memilah bagian kode mana yang akan dipakai. Apalagi jika file yang konflik ada banyak, ditambah selisih waktu antar branch juga panjang.

Jika menggunakan metode biasa, misalnya dengan langsung merge branch feature atau bugs ke branch master, saya cenderung panik terus bingung mau mulai dari mana karena melihat banyaknya file yang konflik.

Jika Anda senasib dengan saya, mungkin Anda bisa mempertimbangkan strategi paranoid ini. Cara ini mungkin lebih ribet, namun bisa menjamin ketenangan hidup Anda.

Untuk mempermudah proses pengabungan, saya menggunakan feature magit emacs `magit-file-checkout`. Saya akan mengambil satu persatu file yang konflik dari branch master ke branch feature atau bugs, kemudian saya selesaikan konfliknya. Oh iya, saya biasa menggunakan magit emacs sebagai interface untuk menjalankan perintah git, jika ada waktu saya akan tuliskan juga perintah-perintah jika menggunakan plain git.

Detail urutannya adalah:

1. Checkout ke branch feature atau bugs.
2. Cek file apa saja yang konflik dengan `magit-merge-preview`. Magit akan memberi tanda **change in both** pada file yang konflik.
3. Ambil/checkout file yang konflik dari branch master dengan `magit-file-checkout`.
3. Selesaikan konflik.
4. Kembali ke langkah 3 untuk mengambil/checkout file lainnya.

Jika sudah selesai, commit seluruh perubahan dan gabungkan branch feature atau bugs ke branch master.