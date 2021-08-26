---
title: "Strategi Merge Branch Git yang Konflik"
date: 2021-08-26T21:06:01+07:00
draft: false
disqus: true
description: "Strategi paranoid untuk merge (menggabungkan) dua branch git yang konflik."
---

Saya termasuk orang yang paranoid saat melihat dua branch git yang akan digabungkan terdapat konflik. Sudah terbayang kesulitan untuk memilih, memilah bagian kode mana yang akan dipakai. Apalagi jika banyak file yang konflik ditambah selisih waktu antar branch juga panjang.

Untuk mempermudah proses pengabungan, saya menggunakan feature magit emacs `magit-file-checkout`. Saya akan mengambil satu persatu file yang konflik dari branch master ke branch feature atau bugs, dan saya selesaikan konfliknya. Saya biasa menggunakan magit emacs sebagai interface untuk menjalankan perintah git, jika ada waktu saya akan tuliskan juga perintah-perintah jika menggunakan plain git.

Detail urutannya adalah:

1. Checkout ke branch feature atau bugs.
2. Cek file apa saja yang konflik dengan `magit-merge-preview`. Magit akan memberi tanda **change in both** pada file yang konflik.
3. Ambil/checkout file yang konflik dari branch master dengan `magit-file-checkout`.
3. Selesaikan konflik.
4. Kembali ke langkah 3 untuk mengambil/checkout file lainnya.

Jika sudah selesai, commit seluruh perubahan dan gabungkan branch feature atau bugs ke branch master.