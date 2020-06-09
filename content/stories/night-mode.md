---
title: "Night Mode"
date: 2020-02-25T22:31:24+07:00
draft: false
toc: true
description: Mode malam (night mode) untuk website. Menggunakan HTML, CSS dan Javascript.
tags: ["tutorial", "hugo"]
disqus: true
---

## Mode Malam

{{< figure src="/images/night-mode/night-mode.png" caption="Mode malam website" alt="Mode malam website" >}}

Mode malam atau dengan nama lain mode gelap (dark mode), sudah menjadi trend desain antarmuka. Banyak aplikasi mobile, desktop bahkan website menerapkannya.

Aplikasi messenger seperti telegram, slack, signals sudah menjadikan ini sebagai fiturnya. Terakhir whatsapp, meluncurkan fitur ini pada aplikasi beta di platform android.

Saya termasuk yang sering menggunakan antarmuka mode malam ini. Memang karena sering membaca dan menggunakan smartphone dimalam hari. Terkadang nyaman juga dipakai disiang hari.

Tampilan layar yang gelap membantu meringankan beban mata saat membaca. Mata tahan lebih lama dan tidak mudah perih.

## Why

Mengikuti trend, web pribadi ini pun akan saya pasang fitur mode malam.

Alasan utamanya lebih pada show off saja. Tulisan-tulisan diweb ini juga tidak terlalu banyak, jadi mungkin tak banyak pengunjung yang membacanya.

Fitur mode malam yang akan diaplikasikan terbilang sederhana. Beberapa baris CSS dan sedikit fungsi javascript sudah cukup memenuhi kebutuhannya.

## Koding

Saya suka dengan mode malam pada aplikasi telegram. Gelap dengan nuansa biru. Mungkin nanti setelah menjelajah web, bisa saya temukan css style dengan nuansa tersebut.

Setelah mempelajari tulisan [ini](https://radu-matei.com/blog/dark-mode/), saya mulai menemukan panduan untuk mengaplikasikannya.

Website ini dibangun dengan framework [hugo](https://gohugo.io/). Pembuatan fitur mode malam tidak ada kaitannya dengan frameworknya. Seluruh kodenya cukup dibuat dengan CSS dan Javascript.

### Cascading Stylesheet

Style yang mirip telegram saya temukan diwebsite [ini](https://userstyles.org/styles/171257/telegram-midnight-for-vk-dark-theme-for-vk). Sebenarnya bisa saja membuat palet warna yang mirip tema telegram secara manual. Warna bisa diambil dari screenshot aplikasi telegram langsung. Tapi malas :D.

```css
/* Night mode */

html {
  background-color: #06090e !important;
  filter: invert(100%) hue-rotate(180deg) brightness(105%) contrast(85%);
  -webkit-filter: invert(100%) hue-rotate(180deg) brightness(105%) contrast(85%);
}

body {
  background-color: #fff !important;
}

img,
video,
body * [style*="background-image"] {
  filter: hue-rotate(180deg) contrast(100%) invert(100%);
  -webkit-filter: hue-rotate(180deg) contrast(100%) invert(100%);
}

#article-toc #TableOfContents a,
.article-content a {
  border-bottom: 3px solid #f8f8f8;
  box-shadow: inset 0 -4px 0 #f8f8f8;
}

#article-toc #TableOfContents a:hover,
.article-content a:hover {
  border-bottom: 3px solid #f8f8f8;
  box-shadow: inset 0 -4px 0 #f8f8f8;
  background: #f8f8f8;
}
```

Setelah utak-atik lumayan lama, penyesuaian dengan tema telegram tidak seperti yang diharapkan. Dan saya rasa cukup dengan hasil yang sekarang. Lain waktu bila lebih didalami lagi.

### Toggle, Tombol Tema

```html
<a
  id="night-mode-toggle"
  title="Toggle Night/Light mode"
  data-current-mode="light"
  style="cursor: pointer;"
></a>
```

### Javascript

Saya menggunakan fitur _localstorage_ pada javascript sebagai penanda browser sedang ada dimode malam (night) atau terang (light).

_localstorage_ merupakan properti pada objek window dijavascript. Memungkinkan kita untuk menyimpan pasangan data key dan value[^1].

[^1]: https://www.w3schools.com/jsref/prop_win_localstorage.asp

Data tetap tersimpan pada browser. Tidak ada kadarluarsa. Bisa dihapus oleh website yang membuatnya, atau secara manual oleh pemilik browser.

```javascript
var toggle = document.getElementById("night-mode-toggle");
var currentMode = toggle.dataset.currentMode;
var nightTheme = document.getElementById("night-mode-theme");
var nightIcon = `<svg viewBox="0 0 24 24" width="15" height="15" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round" class="css-i6dzq1"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg>`;
var lightIcon = `<svg viewBox="0 0 24 24" width="15" height="15" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round" class="css-i6dzq1"><circle cx="12" cy="12" r="5"></circle><line x1="12" y1="1" x2="12" y2="3"></line><line x1="12" y1="21" x2="12" y2="23"></line><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line><line x1="1" y1="12" x2="3" y2="12"></line><line x1="21" y1="12" x2="23" y2="12"></line><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line></svg>`;

toggle.addEventListener("click", () => {
  if (toggle.dataset.currentMode === "light") {
    setTheme("night");
  } else if (toggle.dataset.currentMode === "night") {
    setTheme("light");
  }
});

// the default theme is light
var savedTheme = localStorage.getItem("night-mode-storage") || "light";
setTheme(savedTheme);

function setTheme(mode) {
  localStorage.setItem("night-mode-storage", mode);

  if (mode === "night") {
    nightTheme.disabled = false;
    toggle.dataset.currentMode = "night";
    toggle.innerHTML = lightIcon;
  } else if (mode === "light") {
    nightTheme.disabled = true;
    toggle.dataset.currentMode = "light";
    toggle.innerHTML = nightIcon;
  }
}
```

Untuk tombol tema saya menggunakan icon dari [feather icon](https://feathericons.com/). Icon bulan untuk mode malam, dan icon matahari untuk mode terang.

**Breakdown**

Potongan kode ini menangani saat tombol diklik.

```javascript
toggle.addEventListener("click", () => {
    // ...
}
```

Jika attribute `dataset-current-mode` berisi nilai `light`, akan memanggil fungsi setTheme menjadi mode malam. Dan sebaliknya jika berisi nilai `night`.

Potongan kode ini menginisiasi standar mode yang digunakan.

```javascript
var savedTheme = localStorage.getItem("night-mode-storage") || "light";
setTheme(savedTheme);
```

Jika saat ini adalah kunjungan pertama pengguna. Maka, mode terang yang diterapkan.

`function setTheme`, menerapkan mode sesuai dengan parameter mode yang diberikan.

Fungsi ini juga akan mengganti data penanda mode yang saat ini aktif dan juga icon tombol mode.

## Kesimpulan

Mode malam sudah menjadi trend, memudahkan pengunjung web saat membaca tulisan. Juga memberikan kenyamanan lebih pada mata.

Membangun tema mode malam pada web tidaklah terlalu rumit. Hanya butuh kode sederhana di CSS dan Javascript saja.

Penyesuaian warnanya yang rumit. Perlu mempelajari lebih lanjut fitur filter pada CSS.
