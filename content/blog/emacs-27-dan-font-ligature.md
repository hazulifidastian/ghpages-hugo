---
title: "Emacs 27 dan Font Ligature"
date: 2020-06-18T23:15:25+07:00
draft: false
tags: ["emacs"]
disqus: true
---

Font ligature adalah, karakter spesial pada font yang menggabungkan beberapa karakter berdekatan menjadi satu.

Ligature pada awalnya digunakan pada media cetak tradisional untuk menghemat ruang. Dalam pemrograman, ligature digunakan untuk menyederhanakan dan memperindah kode.

Emacs 27 pada dasarnya tidak mendukung ligature secara khusus, tapi ada beberapa cara untuk mensiasatinya. Tentunya kita perlu menerapkan konfigurasi khusus.

Editor lain, seperti milik JetBrains, VS Code mendukung ligature out of the box. Hanya perlu mengaktifkan opsi mau pakai fitur ligature.

Ada dua font yang saya pakai dalam percobaan ini. Pertama, font milik JetBrains yaitu JetBrains Mono. Dan kedua font buatan komunitas Fira Code, font ini turunan dari Fira Mono.

## JetBrains Mono

Font JetBrains Mono bisa di gunakan gratis. Bisa diunduh pada halaman [ini](https://www.jetbrains.com/lp/mono/).

Pasang font pada sistem operasi kita. Untuk distro turunan Ubuntu, salin file font ke folder ~/.local/share/fonts. Selanjutnya, jalankan perintah fc-cache untuk memperbarui cache font.

Ubah konfigurasi emacs menggunakan set-face-attribute.

```elisp
(set-face-attribute 'default nil
    :family "JetBrains Mono"
    :height 105)
```

Sesuaikan konfigurasi diatas dengan selera Anda di emacs.

Restart emacs Anda.

Sampai disini, tidak akan ada perubahan sama sekali pada emacs. Tidak ada karakter ligature yang muncul. Ini karena kita belum menambahkan konfigurasi untuk mengaktifkan ligaturenya.

Pada halaman web font JetBrains Mono, tidak ada informasi dukungan terhadap editor emacs dan tidak ada juga informasi cara untuk mengkonfigurasinya.

Saya googling. Ketemu dengan dua informasi. Pertama di stackexchange dan issue tracking font JetBrains Mono digithub.

Berikut, saya mulai dengan menerapkan konfigurasi dari stackexchange[^1].

[^1]: https://emacs.stackexchange.com/questions/55059/ligatures-with-the-jetbrains-mono-font

```elisp
(defconst jetbrains-ligature-mode--ligatures
   '("-->" "//" "/**" "/*" "*/" "<!--" ":=" "->>" "<<-" "->" "<-"
     "<=>" "==" "!=" "<=" ">=" "=:=" "!==" "&&" "||" "..." ".."
     "|||" "///" "&&&" "===" "++" "--" "=>" "|>" "<|" "||>" "<||"
     "|||>" "<|||" ">>" "<<" "::=" "|]" "[|" "{|" "|}"
     "[<" ">]" ":?>" ":?" "/=" "[||]" "!!" "?:" "?." "::"
     "+++" "??" "###" "##" ":::" "####" ".?" "?=" "=!=" "<|>"
     "<:" ":<" ":>" ">:" "<>" "***" ";;" "/==" ".=" ".-" "__"
     "=/=" "<-<" "<<<" ">>>" "<=<" "<<=" "<==" "<==>" "==>" "=>>"
     ">=>" ">>=" ">>-" ">-" "<~>" "-<" "-<<" "=<<" "---" "<-|"
     "<=|" "/\\" "\\/" "|=>" "|~>" "<~~" "<~" "~~" "~~>" "~>"
     "<$>" "<$" "$>" "<+>" "<+" "+>" "<*>" "<*" "*>" "</>" "</" "/>"
     "<->" "..<" "~=" "~-" "-~" "~@" "^=" "-|" "_|_" "|-" "||-"
     "|=" "||=" "#{" "#[" "]#" "#(" "#?" "#_" "#_(" "#:" "#!" "#="
     "&="))

(dolist (pat jetbrains-ligature-mode--ligatures)
  (set-char-table-range composition-function-table
                      (aref pat 0)
                      (nconc (char-table-range composition-function-table (aref pat 0))
                             (list (vector (regexp-quote pat)
                                           0
                                    'compose-gstring-for-graphic)))))
```

Hasilnya,

{{< figure src="/images/emacs-27-dan-font-ligature/jetbrains-mono-config-1.png" caption="JetBrains Mono ligature" alt="JetBrains Mono ligature" >}}

Terlihat pada gambar, hasilnya tidak memuaskan. Ada beberapa karakter yang tidak tergabung sempurna. Misal, pada karakter `===`.

Lanjut dengan konfigurasi kedua dari github issue[^2], dengan sebelumnya menghapus konfigurasi dari stackexchange.

[^2]: https://github.com/JetBrains/JetBrainsMono/issues/156#issuecomment-614852962

```elisp
;; Gathered from https://www.jetbrains.com/lp/mono/#ligatures
;; The cheatsheat shows "\/" and "\" which I couldn't get working
(let ((alist '(;;  -> -- --> ->> -< -<< --- -~ -|
               (?- . ".\\(?:--\\|[->]>?\\|<<?\\|[~|]\\)")

               ;; // /* /// /= /== />
               ;; /** is not supported - see https://github.com/JetBrains/JetBrainsMono/issues/202
               ;; /* cannot be conditioned on patterns followed by a whitespace,
               ;; because that would require support for lookaheads in regex.
               ;; We cannot just match on /*\s, because the whitespace would be considered
               ;; as part of the match, but the font only specifies the ligature for /* with
               ;; no trailing characters
               ;;
               (?/ . ".\\(?://?\\|==?\\|\\*\\*?\\|[>]\\)")

               ;; */ *** *>
               ;; Prevent grouping of **/ as *(*/) by actively looking for **/
               ;; which consumes the triple but the font does not define a substitution,
               ;; so it's rendered normally
               (?* . ".\\(?:\\*/\\|\\*\\*\\|[>/]\\)")

               ;; <!-- <<- <- <=> <= <| <|| <||| <|> <: <> <-< <<< <=< <<= <== <==>
               ;; <~> << <-| <=| <~~ <~ <$> <$ <+> <+ <*> <* </ </> <->
               (?< . ".\\(?:==>\\|!--\\|~~\\|-[|<]\\||>\\||\\{1,3\\}\\|<[=<-]?\\|=[><|=]?\\|[*+$~/-]>?\\|[:>]\\)")

               ;; := ::= :?> :? :: ::: :< :>
               (?: . ".\\(?:\\?>\\|:?=\\|::?\\|[>?<]\\)")

               ;; == =:= === => =!= =/= ==> =>>
               (?= . ".\\(?:[=>]?>\\|[:=!/]?=\\)")

               ;;  != !== !!
               (?! . ".\\(?:==?\\|!\\)")

               ;; >= >> >] >: >- >>> >>= >>- >=>
               (?> . ".\\(?:=>\\|>[=>-]\\|[]=:>-]\\)")

               ;; && &&&
               (?& . ".&&?")

               ;; || |> ||> |||> |] |} |-> |=> |- ||- |= ||=
               (?| . ".\\(?:||?>\\||[=-]\\|[=-]>\\|[]>}|=-]\\)")

               ;; ... .. .? .= .- ..<
               (?. . ".\\(?:\\.[.<]?\\|[.?=-]\\)")

               ;; ++ +++ +>
               (?+ . ".\\(?:\\+\\+?\\|>\\)")

               ;; [| [< [||]
               (?\[ . ".\\(?:|\\(?:|]\\)?\\|<\\)")

               ;; {|
               (?{ . ".|")

               ;; ?: ?. ?? ?=
               (?? . ".[:.?=]")

               ;; ## ### #### #{ #[ #( #? #_ #_( #: #! #=
               (?# . ".\\(?:#\\{1,3\\}\\|_(?\\|[{[(?:=!]\\)")

               ;; ;;
               (?\; . ".;")

               ;; __ _|_
               (?_ . ".|?_")

               ;; ~~ ~~> ~> ~= ~- ~@
               (?~ . ".\\(?:~>\\|[>@=~-]\\)")

               ;; $>
               (?$ . ".>")

               ;; ^=
               (?^ . ".=")

               ;; ]#
               (?\] . ".#")
               )))
  (dolist (char-regexp alist)
    (set-char-table-range composition-function-table (car char-regexp)
                          `([,(cdr char-regexp) 0 font-shape-gstring]))))

(let ((ranges '((#x203c . #x3299)
                (#x1f000 . #x1f644))))
  (dolist (emojis ranges)
    (set-fontset-font t emojis "Noto Color Emoji")))

;; Ranges provided by https://github.com/ryanoasis/nerd-fonts/wiki/Glyph-Sets-and-Code-Points
(let ((ranges '(;; Seti-UI + Custom
                (#xe5fa . #xe62b)
                ;; Devicons
                (#xe700 . #xe7c5)
                ;; Font Awesome
                (#xf000 . #xf2e0)
                ;; Font Awesome Extension
                (#xe200 . #xe2a9)
                ;; Material Design Icons
                (#xf500 . #xfd46)
                ;; Weather
                (#xe300 . #xe3eb)
                ;; Octicons
                (#xf400 . #xf4a8)
                #x2665 #x26a1 #xf27c
                ;; Powerline Extra Symbols
                (#xe0b4 . #xe0c8)
                (#xe0cc . #xe0d2)
                #xe0a3 #xe0ca #xe0d4
                ;; IEC Power Sybols
                (#x23fb . #x23fe) #x2b58
                ;; Font Logos
                (#xf300 . #xf313)
                ;; Pomicons
                (#xe000 . #xe00d))))
  (dolist (syms ranges)
    (set-fontset-font t syms "Symbols Nerd Font")))
```

Hasilnya,

{{< figure src="/images/emacs-27-dan-font-ligature/jetbrains-mono-config-2.png" caption="JetBrains Mono ligature" alt="JetBrains Mono ligature" >}}

Terlihat hasilnya lumayan baik, ada sedikit ketidaksempurnaan pada gabungan karakter ===. Namun jauh lebih baik dari pada konfigurasi sebelumnya.

Beberapa saat, konfigurasi terakhir terus saya gunakan untuk aktifitas coding. Sampai saya menemukan masalah yang cukup fatal, emacs tidak merespon saat saya akses beberapa fitur tertentu.

{{< figure src="/images/emacs-27-dan-font-ligature/jetbrains-mono-config-2-hang.png" caption="Emacs hang saat membuka menu flycheck" alt="Emacs hang saat membuka menu flycheck" >}}

Saat membuka menu flycheck show all errors di kode python, dan saat mengakses fitur yang memanggil package helm. Kasus lainnya adalah saat saya membuka file PHP.

Berkali-kali saya harus mematikan paksa emacs. Jika dipantau melalui aplikasi monitoring pada sistem operasi, emacs menghabiskan resource yang besar.

Akhirnya, karena tidak memiliki opsi lain saya menghapus konfigurasi ligature terakhir dan mencoba menggunakan font kedua.

## Fira Code

Font Fira Code didesign oleh beberapa designer, turunan dari font Fira Mono. Informasi lengkapnya dan link untuk mengunduh bisa dilihat [disini](https://github.com/tonsky/FiraCode). Secara personal, saya kurang terlalu suka dengan font ini. Penerapan ini hanya untuk kebutuhan percobaan saja.

Pada halaman githubnya, disertakan informasi dukungan untuk emacs dan cara untuk mengkonfigurasinya.

Ada empat cara konfigurasi yang direkomendasikan pada [halaman](https://github.com/tonsky/FiraCode/wiki/Emacs-instructions#enabling) resminya.

Pilihan konfigurasi pertama, [Using composition mode in Emacs Mac port](https://github.com/tonsky/FiraCode/wiki/Emacs-instructions#using-composition-mode-in-emacs-mac-port) tidak bisa saya terapkan karena saya menggunakan linux.

Pilihan konfigurasi kedua, [
Using prettify-symbols](https://github.com/tonsky/FiraCode/wiki/Emacs-instructions#using-prettify-symbols), tidak menampilkan ligature apapun.

Pilihan konfigurasi keempat, [Using font-lock keywords](https://github.com/tonsky/FiraCode/wiki/Emacs-instructions#using-font-lock-keywords) (ketiga saya lewati dulu), menampilkan karakter-karakter aneh.

{{< figure src="/images/emacs-27-dan-font-ligature/fira-code-config-4.png" caption="Karakter aneh ligature Fira Code" alt="Karakter aneh ligature Fira Code" >}}

Yang berhasil hanya konfigurasi ketiga, [Using composition char table](https://github.com/tonsky/FiraCode/wiki/Emacs-instructions#using-composition-char-table). Kombinasi ligature-nya muncul sempurna. Masalah pada flycheck dan package helm saat menggunakan font JetBrains Mono tidak saya temukan disini.

{{< figure src="/images/emacs-27-dan-font-ligature/fira-code-config-3.jpg" caption="Fira Code ligature" alt="Fira Code ligature" >}}

Saat menggunakan konfigurasi font JetBrains Mono, scrolling kode terasa agak sedikit lag. Hanya sedikit ya, bisa ditoleransi lah. Berbeda dengan Fira Code, scrolling-nya smooth.

Namun smooth-nya tidak bertahan lama, emacs kembali tidak merespon saat membuka file PHP.

Jadi, belum ada konfigurasi ligature yang bisa memuaskan saya. Dan saya berakhir dengan kembali ke plain font JetBrains Mono tanpa ligature.

Btw, tulisan saya ini sangat subjektif. Konfigurasi-konfigurasi diatas terikat dengan environment perangkat lunak dan perangkat keras personal yang saya gunakan sebagai tempat ujicoba. Mungkin hasilnya bisa berbeda jika dijalankan ditempat Anda.

Sebagai tambahan, saya menggunakan:

- Laptop
- Core i3
- 8GB Ram
- SSD
- Elementary OS
- Doom Emacs

Ketika emacs tidak merespon (hang), prosesnya sedang menggunakan banyak resource cpu. Mungkin untuk Anda yang memiliki spesifikasi perangkat keras lebih tinggi hal ini tidak akan terjadi.

Jika Anda punya pengalaman, atau melihat kesalahan dalam implementasi saya, silahkan elaborasikan dikolom komentar.

## Kesimpulan

Fitur ligature pada emacs masih belum kukuh. Konfigurasi diatas adalah cara hacking untuk mengaktifkan fiturnya.

Pada dokumentasi integrasi font Fira Code juga terdapat catatan kelemahan.

{{< figure src="/images/emacs-27-dan-font-ligature/fira-code-catatan.png" caption="Catatan untuk implementasi Fira Code" alt="Catatan untuk implementasi Fira Code" >}}

Emacs 27 sendiri masih belum mencapai versi stabil. Yang saya pakai sekarang masih versi 27.0.91 (beta - CMIIW) bulan april 2020.

Informasinya, emacs 28 akan mendukung ligature out of the box[^3]. Tapi emacs 28 masih versi snapshot, daily build. Versi alphanya pun belum ada.

[^3]: https://github.com/hlissner/doom-emacs/tree/develop/modules/ui/pretty-code#emacs-mac-port-or-emacs-28
