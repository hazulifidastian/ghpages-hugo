---
title: "Roadmap 2022"
date: 2022-04-15T02:22:33+07:00
draft: true
tags: ["roadmap"]
---

Sudah pertengahan bulan April baru nulis roadmap 2022, tenang belum terlambat. Justru
saya punya banyak waktu untuk mempertimbangkan sekian banyak dan rumitnya pilihan untuk
menjalani 2022.

Roadmap 2022 sebenarnya sudah mulai saya rancang dari pertengahan tahun 2021. Saat itu saya
sudah membuat sebagian konsep tulisan untuk roadmap 2021-2022. Namun biasa, jiwa penunda
waktu dan gambaran yang belum matang akan fokus yang mau diambil 2021-2022, tulisan hanya
mengendap difolder draft.

Roadmap disini berkaitan dengan capaian keahlian dibidang teknologi informasi, pemrograman
khususnya. Dibuat sederhana untuk mengarahkan fokus peningkatan keahlian pada tahun 2022.

## Ekosistem

Ada empat ekosistem pemrograman yang ingin saya pelajari:

1. Java Virtual Machine (JVM)
2. Javascript, NodeJS
3. Bogdan's/Björn's Erlang Abstract Machine (Beam)
4. Machine Learning di Python

### Java Virtual Machine (JVM)

Saya penasaran dengan ekosistem JVM, terkenal menjadi basis aplikasi server dengan skala enterprise
dan juga digunakan untuk pengembangan aplikasi di Android (DVM). Fokus saya akan lebih ke arah pengembangan
aplikasi di platform mobile Android. Dan hanya mempelajari secara ringkas untuk sisi backendnya 
(server development).

Sisi backend pada JVM sebenarnya sangat menjanjikan jika saya mau masuk dari bahasa pemrograman Java. Namun 
karena pendekatan saya ke ekosistem ini melalui bahasa pemrograman Kotlin, dan Kotlin sendiri sepertinya masih 
belum mature untuk sisi backendnya. Setidaknya ini pendapat saya saat ini. Tidak menutup kemungkinan
tahun mendatang untuk konsentrasi di sisi backend. Untuk tahun ini konsentrasi di mobile development.

### Javascript, NodeJS

Ada dua tujuan saya untuk masuk ke ekosistem Javascript, pertama untuk pengembangan antar muka (frontend development)
dan kedua untuk pindah dari ekosistem PHP.

Javascript secara defacto adalah bahasa yang digunakan oleh web browser untuk membangun halaman web yang interaktif.
Teknologi seperti React, Graphql dan konsep seperti SPA (singgle page application) menarik perhatian saya. Dulu 
memang pernah belajar Javascript, namun tidak terlalu dalam. Beli buku Express JS, tidak pernah dibaca.

Pernah juga membuat prototype antar muka menggunakan React Native yang dijalankan di Android. Jadi lumayan punya dasar.
Entah kenapa saat itu mundur dari ekosistem Javascript, mungkin karena callback hell, hahaha. Sepertinya saat ini 
Javascript sudah lebih matang. Sekalipun dikritik karena banyaknya library yang buruk dan tidak secure, karena saking
mudahnya bahasa Javascript dan mudahnya membuat library. Hal tersebut bisa diatasi dengan menganalisa library tersebut
dan tidak asal pakai.

Saat ini fokus saya mendalami React sebagai frontend library, konsep single page application dan eksplorasi kapasitas
JS sebagai backend server. Apakah ada framework di Javascript yang sebanding dengan Laravel di PHP? Atau mungkin 
sebanding dengan Django di Python. Menyenangkan sekali punya pengalaman dimanjakan oleh keduanya, Laravel dan Django.

### Bogdan's/Björn's Erlang Abstract Machine (Beam)

Ketertarikan saya pada BEAM hampir sama dengan JVM. BEAM merupakan basis dari aplikasi enterprise, tentunya keduanya 
memiliki konsen yang berbeda. BEAM dengan highly concurency dengan actor modelnya, scalable in nature dan highly 
availability, ketiga fiturnya menopang hampir 90% infrastruktur internet diseluruh dunia melalui perangkat Cisco. Dan
sekitar 40% infrastruktur 3G, 4G dan 5G dari sisi telekomunikasi[^1]. WhatsApp dengan pengguna milyaran, backend servernya 
juga dibangun pada ekosistem BEAM[^2]. Discord juga sama[^3].

Tahun ini saya hanya akan eksplorasi saja fitur-fitur BEAM seperti Erlang OTP, Genserver, fault tolerant. Menambah 
pemahaman tentang konsep high availability dan high scalability di ekosistem BEAM.

[^1]: https://www.erlang-solutions.com/blog/which-companies-are-using-erlang-and-why-mytopdogstatus/
[^2]: https://www.erlang-solutions.com/blog/20-years-of-open-source-erlang-openerlang-interview-with-anton-lavrik-from-whatsapp/
[^3]: https://blog.discord.com/scaling-elixir-f9b8e1e7c29b

### Machine Learning di Python

Dari tahun sebelumnya saya sudah eksplorasi machine learning menggunakan python. Menyesuaikan diri dengan perkembangan
terkini agar tidak terlalu ketinggalan. Mahasiswa dan kampus IT zaman sekarang banyak yang membahas machine learning, dan
saya nggak mau kudet.

Sampai saat ini eksplorasi yang saya lakukan seputar supervised machine learning, regression and classification. Dengan
proyek sederhana deteksi gambar, dan membuat model untuk prediksi dengan linear regression. Tahun ini mungkin belum 
terlalu dalam, karena machine learning sendiri adalah bidang studi sangat luas. Saya masih meraba-raba bagian
yang cocok dengan market dan kemampuan diri saya.

## Bahasa Pemrograman

1. Kotlin
   
   - Ada didalam ekosistem JVM. 
   - Bahasa yang modern, sesuai dengan kebutuhan pengembangan aplikasi terkini
   - Memperbaiki kelemahan pada Java
   - Bahasa dasar populer pada platform Android, bisa juga digunakan juga pada backend
   - Yang paling menarik adalah [Kotlin multiplatform](https://kotlinlang.org/docs/multiplatform.html)

2. Java

   - Verbose, rigid dan strict: Dengan banyak konsep, lapisan abstraksi, pattern dan rule. Diperlukan untuk membangun 
      aplikasi skala besar
   - Bisa dibilang komunitas Java yang paling banyak mengimplementasikan konsep design pattern dan clean architecture
   - Fokus belajar pemrograman dengan cara berfikir yang lebih konseptual dalam menyelesaikan masalah

3. Javascript, NodeJS

   - The king of client side programming language
   - Async, non blocking IO
   - New framework everyday :laughing:
   - React ecosystem

4. Elixir

   - Ruby in mind. Sempat belajar Ruby (Ruby on Rails), suka sama syntaxnya tapi kurang suka sama magicnya. Akhirnya
      lebih memilih python saat itu. Elixir "adalah ruby tanpa magic" plus performance from Erlang concurency.
   - Functional programming, lebih mudah dipelajari dibanding Erlang
   - Fault tolerant
   - Powerfull feature, Erlang OTP
   - Simple language

5. Erlang

   - Elixir dibangun diatas Erlang, dan BEAM dibangun dengan Erlang. Jadi, tidak cukup hanya belajar Elixir saja.

## Skala Keseriusan dan Fokus

<table class="table is-hoverable">
  <thead>
    <tr>
      <th>Topik</th>
      <th>Skala</th>
      <th>Fokus</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Java Virtual Machine (JVM)</td>
      <td>Serius</td>
      <td>Android (DVM)</td>
    </tr>
    <tr>
      <td>Kotlin</td>
      <td>Serius Banget</td>
      <td>Android</td>
    </tr>
    <tr>
      <td>Java</td>
      <td>Serius</td>
      <td>Strict and rigid application architecture, Design pattern, Spring</td>
    </tr>
    <tr>
      <td>Javascript</td>
      <td>Serius</td>
      <td>React, Singgle page application (SPA)</td>
    </tr>
    <tr>
      <td>Bogdan's/Björn's Erlang Abstract Machine (Beam)</td>
      <td>Santai Banget</td>
      <td>Erlang OTP, councurency, availability, scalability</td>
    </tr>
    <tr>
      <td>Elixir</td>
      <td>Santai Banget</td>
      <td>Basic Elixir</td>
    </tr>
    <tr>
      <td>Erlang</td>
      <td>Santai Banget</td>
      <td>Basic Erlang</td>
    </tr>
    <tr>
      <td>Machine Learning di Python</td>
      <td>Santai Banget</td>
      <td>Computer vision, supervised machine learning</td>
    </tr>
  </tbody>
</table>

## Resources

<table class="table is-hoverable">
  <thead>
    <tr>
      <th>Topik</th>
      <th>Resource</th>
      <th>URL</th>
      <th>Keterangan</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Kotlin</td>
      <td>Pemrograman Kotlin : Pemula sampai Mahir</td>
      <td><a href="https://www.udemy.com/course/pemrograman-kotlin-pemula-sampai-mahir/">Link</a></td>
      <td>Video tutorial</td>
    </tr>
    <tr>
      <td></td>
      <td>Philipp Lackner Channel</td>
      <td><a href="https://www.youtube.com/c/PhilippLackner">Link</a></td>
      <td>Video tutorial Kotlin android dan ktor</td>
    </tr>
    <tr>
      <td>Java</td>
      <td>Pemrograman Java : Pemula sampai Mahir</td>
      <td><a href="https://www.udemy.com/course/pemrograman-java-pemula-sampai-mahir">Link</a></td>
      <td>Video tutorial</td>
    </tr>
    <tr>
      <td>Javascript</td>
      <td>Next Amazona: Build ECommerce Website Like Amazon By Next.JS</td>
      <td><a href="https://www.udemy.com/course/nextjs-ecommerce/">Link</a></td>
      <td>Video tutorial</td>
    </tr>
    <tr>
      <td></td>
      <td>React - The Complete Guide (incl Hooks, React Router, Redux)</td>
      <td><a href="https://www.udemy.com/course/react-the-complete-guide-incl-redux/">Link</a></td>
      <td>Video tutorial</td>
    </tr>
    <tr>
      <td></td>
      <td>RedwoodJS</td>
      <td><a href="https://redwoodjs.com/docs/introduction">Link</a></td>
      <td></td>
    </tr>
    <tr>
      <td>Elixir</td>
      <td>Programming Elixir 1.6</td>
      <td><a href="https://pragprog.com/titles/elixir16/programming-elixir-1-6/">Link</a></td>
      <td>Buku</td>
    </tr>
    <tr>
      <td>Erlang</td>
      <td>Learn You Some Erlang</td>
      <td><a href="https://learnyousomeerlang.com/">Link</a></td>
      <td>Buku online</td>
    </tr>
    <tr>
      <td>Machine Learning Python</td>
      <td>Murtaza's Workshop - Robotics and AI Channel</td>
      <td><a href="https://www.youtube.com/c/MurtazasWorkshopRoboticsandAI">Link</a></td>
      <td>Computer vision, OPENCV</td>
    </tr>
    <tr>
      <td></td>
      <td>Nicholas Renotte Channel</td>
      <td><a href="https://www.youtube.com/c/NicholasRenotte">Link</a></td>
      <td>Computer vision, OPENCV</td>
    </tr>
  </tbody>
</table>


