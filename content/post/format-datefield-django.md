---
title: "Format DateField Django"
date: 2019-01-22T07:00:00+07:00
draft: true
tags: ["django"]
---

Beberapa cara penggunaan format DateField didjango form.

<!--more-->

## Format Spesifik

Menentukan format spesifik DateField pada form. Jika pengguna memasukkan tanggal diluar format tersebut, form akan menampilkan error saat validasi.

```python
# forms.py
class MyForm(forms.ModelForm):
    # Hanya menerima input dengan format contoh: 25/01/2019    
    tanggal = forms.DateField(input_formats='%d-%m-%Y')
```

Konfigurasi DATE_INPUT_FORMATS pada settings.py untuk menampilkan format output yang diinginkan pada DateField.

```python
# settings.py
DATE_INPUT_FORMATS = '%d-%m-%Y'
```

## Penggunaan yang Salah!

Jika `DATE_INPUT_FORMATS` tidak di set, django akan melihat konfigurasi `LANGUAGE_CODE` pada settings.py. Contoh jika file `settings.py` `LANGUAGE_CODE='id-id'` Django akan memanggil default format dari konfigurasi global `conf/locale/id/formats.py`.

```python
# conf/locale/id/formats.py
DATE_INPUT_FORMATS = [
    '%d-%m-%y', '%d/%m/%y',             # '25-10-09', 25/10/09'
    '%d-%m-%Y', '%d/%m/%Y',             # '25-10-2009', 25/10/2009'
    '%d %b %Y',                         # '25 Oct 2006',
    '%d %B %Y',                         # '25 October 2006'
]
```

Pada konfigurasi global `formats.py` diatas, format default yang akan digunakan setelah form berhasil disimpan dan data tanggal akan ditampilkan kembali pada input adalah indeks pertama dari `DATE_INPUT_FORMAT` yaitu,`'%d-%m-%y'`. Dan hasil yang terlihat pada input adalah `25-01-19`.

```plaintext
Tanggal yang diinput
+— — — — — — +
| 25–01–2019 |
+ — — — — — —+

Setelah disimpan, field tanggal menampilkan informasi yang berbeda
+— — — — — — +
| 25–01–19   |
+ — — — — — —+
```

Jadi set variabel `DATE_INPUT_FORMATS='%d-%m-%Y'` untuk menampilkan format tanggal yang sama dengan yang diinputkan.

## Format Alternatif

Langkah pertama menggunakan format alternatif pada DateField adalah, properti `format_inputs=` saat inisiasi tidak perlu digunakan,

```python
# forms.py
class MyForm(forms.ModelForm):  
    tanggal = forms.DateField()
```

Django akan melihat format alternatif pada conf/locale/id/formats.py jika menggunakan konfigurasi `LANGUAGE_CODE='id-id'`

Atau bisa di set langsung pada `settings.py`,

```python
# settings.py
DATE_INPUT_FORMATS = [
    '%d-%m-%y', '%d/%m/%y',             # '25-10-09', 25/10/09'
    '%d-%m-%Y', '%d/%m/%Y',             # '25-10-2009', 25/10/2009'
    '%d %b %Y',                         # '25 Oct 2006',
    '%d %B %Y',                         # '25 October 2006'
]
```

Ganti prioritas format dengan menggeser indexnya,

```python
# settings.py
DATE_INPUT_FORMATS = [
    '%d-%m-%Y', '%d/%m/%Y',             # '25-10-2009', 25/10/2009'
    '%d-%m-%y', '%d/%m/%y',             # '25-10-09', 25/10/09'
    '%d %b %Y',                         # '25 Oct 2006',
    '%d %B %Y',                         # '25 October 2006'
]
```

Diatas, prioritas saat input dan output data DateField diganti dari `%d-%m-%y` menjadi `%d-%m-%Y` (perhatikan huruf Y diakhir format).

Maka input pada browser akan menampilkan informasi tanggal yang sama.

```plaintext
Tanggal yang diinput
+— — — — — — +
| 25–01–2019 |
+ — — — — — —+

Setelah disimpan, field tanggal akan menampilkan informasi yang sama.
+— — — — — — +
| 25-01-2019 |
+ — — — — — —+
```

**_Catatan_**:

Pada format alternatif, form akan melakukan validasi tanggal sesuai dengan kemungkinan format yang akan muncul pada setting variabel `DATE_INPUT_FORMATS`

```plaintext
Input tanggal pada browser menerima alternatif format
berdasarkan konfigurasi DATE_INPUT_FORMATS

Tanggal yang diinput
+— — — — — — +
| 25–01–2019 |
+ — — — — — —+

+— — — — — -+
| 25–01–19  |
+ — — — — — +

+— — — — — — +
| 25/01/2019 |
+ — — — — — —+

Semua input diatas akan diterima.
```
