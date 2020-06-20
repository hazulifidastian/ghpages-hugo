---
title: "Project Workflow"
date: 2020-06-19T22:04:00+07:00
draft: false
tags: ["github", "manajemen proyek"]
toc: true
disqus: true
description: "Tulisan ini berisi gambaran mengenai alur kerja saya dalam memanajemeni sebuah proyek."
---

## Flashback

Saya pernah menggunakan [taiga.io](https://taiga.io) untuk membantu memanajemeni proyek saya. Fiturnya banyak, gratis lagi. Saya pasang di komputer personal memanajemeni proyek dalam lingkungan lokal.

Dulu, saya juga menggunakan [redmine](https://www.redmine.org/), aplikasi manajemen proyek yang dibuat dengan framework ruby on rails. Gratis. Bisa diunduh dan dipasang di komputer personal. Saat itu zaman IDE netbeans sedang hype dan svn masih populer sebagai aplikasi manajemen _source code_ . Berarti sudah lama sekali.

Aplikasi [JIRA](https://www.atlassian.com/software/jira) termasuk yang pernah saya coba, tapi hanya sekedar mencoba. Tidak seserius dua aplikasi sebelumnya.

Ada pula [Git Flow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow). Ini metode yang digunakan untuk memudahkan memanajemeni pengembangan _source code_ dan rilisnya. Sangat bermanfaat jika proyek memiliki banyak pengembangnya (developer). Kalau digunakan oleh pekerja lepas, bekerja sendirian, maka ini bisa disebut sebagai over engineering.

Beberapa bulan terakhir saya mempelajari alternatif baru. Alternatif untuk memanajemeni proyek. Pada proyek terakhir, saya hanya menggunakan aplikasi [Microsoft Todo](https://todo.microsoft.com). Ternyata, proyeknya berkembang menjadi kompleks dan saya pun tersesat di dalam hutan bugs, fitur dan hotfix.

Tidak menyenangkan kehilangan arah. Maklum saya FULLSTACK Developer. Ya, FULLSTACK dengan huruf besar. Artinya, saya pengembang aplikasi yang mengurusi mulai dari padding dan margin dalam file `style.css`. Hingga deployment mengunakan docker berisi container nginx, redis dan postgres.

Jadi, kembali menentukan alur kerja proyek (project workflow) akan membantu saya untuk keluar dari hutan masalah. Sekaligus menjadikan alur kerja ini sebagai pondasi untuk proyek-proyek selanjutnya.

## Eksplorasi Solusi

Untuk memanajemeni kode, saya tertarik dengan [GitHub Flow](https://guides.github.com/introduction/flow/) (berbeda dengan Git Flow). GitHub Flow sangat sederhana. Jika Git Flow memiliki dua branch utama, master dan develop, maka Github Flow hanya memiliki satu branch utama, yaitu master.

Aturan utamanya, kode yang ada di master, adalah kode yang siap dideploy (deployable). Setiap pengembangan fitur, perbaikan bugs dan hotfix harus bebasis dari master dan kembali digabungkan ke master.

GitHub Flow mirip dengan metode pengembangan lain, yaitu [Trunk Based Development](https://trunkbaseddevelopment.com/).

Untuk manajemen proyek secara umum, saya suka dengan fitur manajemen issue yang ada pada Github. Fitur ini masih gratis. Sekalipun repository proyek saya berstatus private.

Saya bisa memulai pengembangan bagian-bagian proyek menggunakan fitur manajemen issue ini. Ya bisa dibilang mirip backlog story pada metode scrum.

Sebuah issue bisa diberikan label, milestone dan projects.

Label issue bisa berupa bugs, enhancement, dan lain-lain. Label ini bisa diintegrasikan dengan fitur projects yang berisi kanban board. Disini bisa dilihat visualisasi progres pengembangan aplikasi.

Apakah mungkin bisa kehilangan arah? Ya mungkin saja kalau tidak mau diperbarui progresnya. Jika selalu disiplin memperbarui, proyek yg sudah ditinggal lama pun akan mudah untuk mengingatnya kembali.

## Alur Kerja

### Memulai Proyek

**GitHub**

1. Buat repository baru github.
2. Tambahkan project dengan nama Feature ke repository baru, ini digunakan untuk memantau progres sebuah fitur. Kemudian project dengan nama Bugs untuk memantau progress perbaikan bugs. Terakhir project dengan nama Hotfix.

**Perangkat Personal**

1.  Buat folder proyek pada perangkat kerja lokal dan inisiasi menjadi repository git.

    ```bash
    git init
    ```

2.  Tambah file `.gitignore` mengunakan aplikasi dari [gitignore.io](https://www.toptal.com/developers/gitignore).
    ```bash
    gi python,django
    ```
    Perintah diatas akan membuat file `.gitignore` untuk python dan django.
3.  Lakukan commit pertama kali.
    ```bash
    git commit -m "Initial commit"
    ```
4.  Push repository lokal ke repository github, dengan sebelumnya menambahkan remote url.
    ```bash
    git remote add origin git@...
    git push -u origin master
    ```

### Manajemen Feature

Dari hasil analisa kebutuhan proyek, bisa ditentukan fitur-fitur apa saja yang akan dikerjakan. Dari sini bisa dibuat issue baru dengan nama fitur tersebut.

{{< figure src="/images/project-workflow/github-bagian-issue.png" caption="Bagian issue github" alt="Bagian issue github" >}}

#### Buat Issue Baru

Saat membuat issue baru,

- Isi nama issue dengan jelas
- Sertakan keterangan yang lengkap pada deskripsi
- Issue di assign ke orang yang bertanggung jawab. Tetapi kalau proyek hanya kita sendiri pengembangnya, ya di assign ke diri sendiri.
- Tentukan **labelnya** sebagai **enhancement**.
- Pilih **Feature** pada bagian **Projects**.
- Untuk milestone bisa dikosongkan. Atau bisa input data baru, misalnya "Demo". Artinya fitur ini ditargetkan selesai untuk kebutuhan demo. Jika proyek sudah berkembang, bisa menambahkan milestone baru misalnya v1.0.0. Bebas, intinya target yang ingin dicapai.

{{< figure src="/images/project-workflow/github-issue-baru.png" caption="Issue baru" alt="Issue baru" >}}

Ok. Selesai dengan manajemen issue. Jangan lupa ingat nomor issuenya, angka yang dimulai dengan karakter **#**. Nomornya keluar setelah klik tombol **Submit New Issue**.

#### Pengembangan Fitur

Sekarang mari mulai mengerjakan fitur tersebut.

Buka bagian **Projects**, pilih **Feature**. Akan terlihat kartu kecil di kolom **To do**, berisi nama fitur yang akan dikerjakan. Pindahkan kartu tersebut ke kolom **In progress**. Ini tanda dimulai pengerjaan.

{{< figure src="/images/project-workflow/github-project-feature.png" caption="Project Feature" alt="Project Feature" >}}

Kembali ke perangkat personal. Buat branch baru pada _source code_. Branch ini harus berisi nama fitur, bisa juga ditambahkan dengan nomor issue fitur yang didapat dari github.

```bash
git checkout -b feature-#1 master
git push origin -b feature-#1
```

Secara berkala, perubahan pada master (jika ada) harus digabungkan kembali ke branch fitur. Atasi konflik pada _source code_ jika ada.

```bash
git merge master
```

Secara berkala, push perubahan ke github.

```bash
git push origin feature-#1
```

#### Open Pull Request

Open pull request adalah permintaan untuk menggabungkan perubahan terbaru dengan branch origin/master pada github.

1. Klik menu pull request, lanjutkan dengan memilih base branch, yaitu branch master. Kemudian pilih branch fitur akan digabungkan

   {{< figure src="/images/project-workflow/github-pull-request.png" caption="Open pull request" alt="Open pull request" >}}

2. Review kode, dan berikan komentar sebagai catatan

3. Merge pull request

   {{< figure src="/images/project-workflow/github-merge-pull-request.png" caption="Merge pull request" alt="Merge pull request" >}}

4. Hapus branch feature-#1

   {{< figure src="/images/project-workflow/github-delete-feature-branch.png" caption="Delete branch fitur" alt="Delete branch fitur" >}}

#### Close issue

Buka halaman **Issue**. Klik issue feature-#1 yang baru diselesaikan dan Klik tombol **Close Issue**.

{{< figure src="/images/project-workflow/github-close-issue.png" caption="Close issue" alt="Close issue" >}}

Klik bagian **Projects**. Pindahkan kartu feature yang baru saja selesai digabungkan ke kolom **Done**.

{{< figure src="/images/project-workflow/github-project-issue-done.png" caption="Project issue Done" alt="Project issue Done" >}}

#### Perbarui Repository lokal

Setelah proses pull request selesai, perbarui repository lokal untuk menyesuaikan perubahan pada repository remote di github.

```bash
git fetch
```

Perintah untuk membandingkan perbedaan repository,

```bash
git log --oneline master origin/master  # perbedaan commit
git diff master origin/master  # perbedaan kode
```

Gabungkan branch origin/master ke master.

```bash
git checkout master
git merge origin/master
```

Hapus branch feature.

```bash
git branch -d feature-#1
```

### Manajemen Bugs

1. Buat issue baru. Isi input label dan project dengan nama **Bugs**
2. Pindahkan kartu issue pada halaman **Project - Bugs** ke kolom **To do**
3. Buat branch baru pada repository lokal,
4. Pindahkan kartu issue pada halaman **Project - Bugs** ke kolom **In progress**
5. Sesuaikan branch bug dengan perubahan pada branch master secara berkala
   ```bash
   git merge master
   ```
6. Push perubahan pada branch bug secara berkala
   ```bash
   git push origin bug-#2
   ```
7. Open pull request branch master dengan bug. Review, merge dan delete branch pull request jika sudah selesai.
8. Close issue bug #2, dan pindahkan kartu bug #2 pada halaman **Projects Bugs** ke kolom **Done**
9. Perbarui repository lokal
   ```bash
   git fetch
   git log --oneline master origin/master  # perbedaan commit
   git diff master origin/master  # perbedaan kode
   git checkout master
   git merge origin/master
   git branch -d bug-#2
   ```

### Manajemen Hotfix

1. Buat issue baru. Isi input label dan project dengan nama **Hotfix**
2. Pindahkan kartu issue pada halaman **Project - Hotfix** ke kolom **To do**
3. Buat branch baru pada repository lokal,
4. Pindahkan kartu issue pada halaman **Project - Hotfix** ke kolom **In progress**
5. Sesuaikan branch hotfix dengan perubahan pada branch master secara berkala
   ```bash
   git merge master
   ```
6. Push perubahan pada branch hotfix secara berkala
   ```bash
   git push origin hotfix-#3
   ```
7. Open pull request branch master dengan hotfix. Review, merge dan delete branch pull request jika sudah selesai.
8. Close issue hotfix #3, dan pindahkan kartu hotfix #3 pada halaman **Projects - Hotfix** ke kolom **Done**
9. Perbarui repository lokal
   ```bash
   git fetch
   git log --oneline master origin/master  # perbedaan commit
   git diff master origin/master  # perbedaan kode
   git checkout master
   git merge origin/master
   git branch -d hotfix-#3
   ```
10. Merge master ke seluruh branch.

## Kesimpulan

Github menyediakan fitur untuk mempermudah memanajemeni proyek. Fitur-fitur tersebut bisa diakses gratis. Apalagi dikombinasikan dengan GitHub Flow, dengan kesederhanaanya membuat pengembangan proyek lebih terkontrol.

Perlu kedisiplinan tinggi untuk mengikuti alur kerja ini. Kelihatannya merepotkan, tapi jika proyeknya besar dan waktu pengerjaannya lama, hasilnya akan sebanding dengan usaha. Semua catatan selama proses pengembangan bisa didokumentasikan padda fitur Issue, Projects, Pull Requests. Github sendiri memiliki fitur komentar, ditempat itu bisa dicatat usaha-usaha yang dilakukan untuk menuntaskan satu fitur atau memperbaiki satu bug.

Catatan-catatan itu berguna untuk proyek-proyek selanjutnya. Jika menghadapi permasalahan yang sama, bisa merujuk kembali pada catatan itu.

Solusi ini efektif buat saya, setiap pengembang aplikasi punya background dan pengalaman sendiri. Silahkan bereksplorasi sesuai dengan kebutuhannya.

Jangan sungkan untuk meng-elaborasikan pendapat Anda dikolom komentar. Saya menerima kritik, saran dan koreksi.
