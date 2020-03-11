---
title: "Lightline & winwidth Nvim"
date: 2020-03-09T11:51:46+07:00
draft: false
tags: ["nvim", "lightline"]
disqus: true
---

Pembahasan kali ini adalah tentang statusline di Nvim. Statusline adalah, garis horizontal
yang ada dibagian bawah nvim. Ia menampilkan status dari buffer/file yang sedang aktif.

Statusline bisa ditampilkan dalam beberapa bagian. Bisa berisi mode vim, nama file, direktori
dari file, posisi kursor, dll.

Untuk mempermudah mengatur tampilan informasi pada statusline, saya menggunakan plugin
Lightline[^1]. Plugin ini ringan, dan mudah dikustomisasi. Kita bisa juga dengan mudah 
mengatur tema untuk menambah indah tampilan editor.

[^1]: https://github.com/itchyny/lightline.vim

Kendala yang saya alami saat menggunakan Lightline adalah, ketika saya mengecilkan terminal.
Atau, ketika saya membagi window menjadi beberapa bagian horizontal (split horizontal). Informasi 
yang saya prioritaskan untuk saya lihat, menghilang dari statusline. Yang tampil malah informasi 
yang tidak saya prioritaskan.

Tulisan ini membahas bagaimana cara mengatur informasi yang tampil pada statusline tersebut.
Terutama ketika window memiliki ruang horizontal yang sempit.

**Konfigurasi**

Ketika kita menginisiasi lightline, kita akan mengatur variabel tipe dictionaries dengan
nama `g:lightline`, dan dengan key `component_function`.

```viml
let g:lightline = {
    \   'active': {
    \       'left':[ [ '...' ], ['gitbranch' , '...']
    \     ],
    \       'right':[ ['...'], ['...', 'cocstatus']
    \     ],
    \   },
    \   'component_function': {
    \     'gitbranch': 'LightlineFugitiveHead',
    \     'cocstatus': 'LightlineCocStatus',
    \   }
    \ }
```

Penjelasan pengaturan dengan contoh kode diatas adalah, tampilkan `gitbranch` pada statusline 
aktif pada bagian kiri, dan `cocstatus` pada bagian kanan.

Sedikit penjelasan, `gitbranch` berisi informasi branch/cabang git yang sedang aktif pada sebuah
repository Git. `cocstatus` adalah informasi yang berasal dari plugin `Coc`[^2].

[^2]: https://github.com/neoclide/coc.nvim

`gitbranch` dan `cocstatus` tersebut terhubung dengan `gitbranch` dan `cocstatus` pada bagian 
`component_function`. Yang artinya, ketika statusline akan menampilkan `gitbranch` dan `cocstatus`,
maka statusline akan mengeksekusi fungsi yang sudah diatur pada pengaturan `component_function`.

Ketika akan menampilkan `gitbranch`, maka fungsi `LightlineFugitiveHead` akan dieksekusi. Untuk `cocstatus`,
maka fungsi `LightlineCocStatus` yang akan dieksekusi.

Pada contoh pengaturan diatas, kita sebenarnya membuat fungsi sendiri dengan nama, `LightlineFugitiveHead`, 
dan `LightlineCocStatus`. Didalam fungsi inilah kita mengatur mekanisme untuk menampilkan 
informasi pada statusline.

```viml
" Lebar minimal window
let g:minwidth = 120

function! LightlineFugitiveHead() abort
    " Cek, apakah lebar window > dari lebar minimal
    " Jika Ya, tampilkan informasi gitbranch
    if (winwidth(0) > g:minwidth)
        if exists('*FugitiveHead')
            let branch = FugitiveHead()
            return branch !=# '' ? '⽊ '.branch : ''
        endif
    endif
    return ''
endfunction

function! LightlineCocStatus() abort
    " Cek, apakah lebar window > dari lebar minimal
    " Jika Ya, tampilkan informasi cocstatus
    if (winwidth(0) > g:minwidth)
        return coc#status()
    endif
    return ''
endfunction
```

Kode diatas adalah contoh fungsi yang didalamnya melakukan pengecekan, apakah
lebar window lebih besar dari nilai variabel lebar minimal window. Nilai variabel 
lebar minimal window adalah `120`.

Jika lebar window lebih besar, maka bagian `gitbranch` dan `cocstatus` akan ditampilkan.
Jika lebih kecil, maka `gitbranch` dan `cocstatus` akan disembunyikan.

**Kesimpulan**

Dengan memadukan fungsi `winwidth` dan fleksibilitas plugin lightline, kita dengan mudah
mengatur informasi apa saja yang tampil pada statusline dalam kondisi lebar window
tertentu.

Konfigurasi diatas tidak hanya digunakan untuk menampilkan `gitbranch` dan `cocstatus` saja.
Bisa menyesuaikan dengan kebutuhan sendiri dan untuk bagian-bagian statusline yang lain.

Fungsi `winwidth` dari Nvim membantu kita untuk menentukan lebar window pada sebuah buffer.

Untuk melihat konfigurasi lengkap saya untuk lightline, bisa ikuti 
[tautan ini](https://github.com/hazulifidastian/dotfiles/blob/master/.config/nvim/init.vim.d/plugins.d/lightline.vim).
