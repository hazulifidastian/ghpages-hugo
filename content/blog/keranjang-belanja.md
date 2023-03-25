---
title: "Keranjang Belanja"
date: 2022-02-11T10:35:57+07:00
draft: true
disqus: true
toc: true
description: "Keranjang belanja interaktif menggunakan Django dan Django Ninja Rest Framework"
---

## Umum

Saya membuat aplikasi sederhana yang berfungsi seperti keranjang belanja pada toko online. Aplikasi ini akan menggunakan fitur Rest API pada library Django Ninja Rest Framework.

Dibagian backend saya menggunakan Django sebagai framework dan kemudian didukung library Django Ninja Rest Framework untuk menangani request. Saya gunakan database SQLite3, ini setup default dari django.

Pada bagian frontend saya gunakan HTML, Js dan Bootstrap. Halaman akan dibuat reaktif menggunakan AlpineJS.

## Teknis

Aplikasi terdiri dari dua halaman:

1. Halaman produk. Halaman ini berisi daftar produk beserta tombol tambah ke keranjang.
2. Halaman keranjang. Halaman ini akan menampilkan produk yang sudah ditambahkan ke keranjang beserta fitur edit, hapus dan perhitungan total harga.

Halaman produk akan menampilkan daftar produk yang diambil dari server Django & Django Ninja Rest Framework. Saat pengguna klik tombol "Tambah ke Keranjang", informasi produk akan dikirim ke server untuk ditambahkan ke database pada tabel keranjang.

Halaman keranjang berisi daftar produk yang sudah ditambahkan. Produk bisa ditambah kuantitasnya, dan bisa juga dihapus dari keranjang. Setiap perubahan aplikasi akan menghitung total harga, dan mengirimkan perubahan ke server.

## Setup

```bash
mkdir KeranjangBelanja
cd KeranjangBelanja
```

### Install Django Ninja

**Menggunakan `pip` virtualenv**

```bash
pip install django-ninja
```

**Menggunakan `poetry`**

```bash
poetry init
poetry add django-ninja
```

### Mulai Django Project

```bash
# Mulai project
django-admin startproject keranjangbelanja .

# Inisiasi database
manage.py migrate

# Buat akun superuser
manage.py createsuperuser
```

### Hello World

Buat file di `keranjangbelanja/api.urls`

```python
from ninja import NinjaAPI

api = NinjaAPI()


@api.get('hello')
def hello(request):
    return {'hello': 'World!'}
```

Tambahkan kode di `keranjangbelanja/urls.py`.

```python
from django.contrib import admin
from django.urls import path

from .api import api

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', api.urls),
]
```

**Jalankan server django**

```bash
manage.py runserver
```

Buka browser dengan url `http://127.0.0.1:8000/api/hello`, server akan mengembalikan json

```
{'hello': 'World!'}
```

## Model

Kita perlu dua model Produk dan Keranjang. Masing-masing akan saya buat kan app django tersendiri. Sebenarnya bisa digabung jadi satu django app saja, namun untuk tulisan ini kita pisah agar sekalian bisa melihat bagaimanana setup API Django Ninja dalam dua app atau folder yang berbeda.

Btw, bagi Django beginner, app adalah modul yang ada didalam aplikasi utama django. Misalnya kita punya aplikasi `keranjangbelanja` maka `produk` dan `keranjang` adalah dua app yang ada didalamnya. Bentuknya berupa folder, yang masing-masing punya fungsi yang independen.


### Buat Dua App

Jalankan perintah untuk membuat app produk dan keranjang.

```bash
manage.py startapp produk
manage.py startapp keranjang
```

Tambahkan app pada file variabel `INSTALLED_APPS` di `settings.py`.

```python
INSTALLED_APPS = [
    # ...
    'django.contrib.staticfiles',
    'produk',
    'keranjang',
]
```

### Class Produk dan Keranjang

Tambahkan model `Produk` pada file `produk/models.py`.

```python
from django.db import models


class Produk(models.Model):
    nama = models.CharField(max_length=255)
    harga = models.IntegerField()
    thumbnail = models.URLField(blank=True, null=True)
    created = models.DateTimeField(auto_now_add=True, editable=False)
    updated = models.DateTimeField(auto_now=True, editable=False)
```

Tambahkan model `Keranjang` pada file `keranjang/models.py`.

```python
from django.db import models

from produk.models import Produk

class Keranjang(models.Model):
    produk = models.ForeignKey(Produk, on_delete=models.CASCADE)
    kuantitas = models.IntegerField()
    created = models.DateTimeField(auto_now_add=True, editable=False)
    updated = models.DateTimeField(auto_now=True, editable=False)
```


### Migrasi Database

```
manage.py makemigrations
manage.py migrate
```

Dengan `settings.py` default, Django akan menginisiasi database SQLite3 dengan file `db.sqlite3` pada folder project. Database itu berisi dua tabel, produk dan keranjang selain tabel bawaan dari Django.

## API

### Router Produk

Buat file `produk/api.py` dan tambahkan kode

```python
from typing import List

from django.shortcuts import get_object_or_404
from ninja import Router

from produk.models import Produk
from produk.schemas import ProdukOut, ProdukIn

router = Router(tags=['produk'])


@router.get('', response=List[ProdukOut])
def list_produk(request):
    return Produk.objects.all()


@router.get('{int:produk_id}', response=List[ProdukOut])
def get_produk(request, produk_id: int):
    return get_object_or_404(Produk, id=produk_id)


@router.post('', response=ProdukOut)
def post_produk(request, payload: ProdukIn):
    produk = Produk.objects.create(**payload.dict())
    return produk


@router.put('{int:produk_id}')
def put_produk(request, produk_id: int, payload: ProdukIn):
    produk = get_object_or_404(Produk, id=produk_id)
    for attr, value in payload.dict().items():
        setattr(produk, attr, value)
    produk.save()
    return {'success': True}


@router.delete('{int:produk_id}')
def delete_produk(request, produk_id: int):
    produk = get_object_or_404(Produk, id=produk_id)
    produk.delete()
    return {'success': True}
```

Kemudian panggil router produk dari file `keranjangbelanja/api.py`

```python {hl_lines=[3,7]}
from ninja import NinjaAPI

from produk.api import router as produk_router

api = NinjaAPI()

api.add_router('/produk/', produk_router)
```

### Router Keranjang

Buat file `keranjang/api.py`. Tambahkan kode

```python
from typing import List

from django.shortcuts import get_object_or_404
from ninja import Router

from keranjang.models import Keranjang
from keranjang.schemas import KeranjangIn, KeranjangOut, KeranjangUpdateIn

router = Router(tags=['keranjang'])


@router.get('', response=List[KeranjangOut])
def list_keranjang(request):
    return Keranjang.objects.all()


@router.post('', response=KeranjangOut)
def post_keranjang(request, payload: KeranjangIn):
    keranjang = Keranjang.objects.create(**payload.dict())
    return keranjang


@router.put('{int:keranjang_id}')
def put_keranjang(request, keranjang_id: int, payload: KeranjangUpdateIn):
    keranjang = get_object_or_404(Keranjang, id=keranjang_id)
    for attr, value in payload.dict().items():
        setattr(keranjang, attr, value)
    keranjang.save()
    return {'success': True}


@router.delete('{int:keranjang_id}')
def delete_keranjang(request, keranjang_id: int):
    keranjang = get_object_or_404(Keranjang, id=keranjang_id)
    keranjang.delete()
    return {'success': True}
```

Kemudian panggil router keranjang dari file `keranjangbelanja/api.py`

```python {hl_lines=[3,9]}
from ninja import NinjaAPI

from keranjang.api import router as keranjang_router
from produk.api import router as produk_router

api = NinjaAPI()

api.add_router('/produk/', produk_router)
api.add_router('/keranjang/', keranjang_router)

```

### Inisiasi Data Dengan API Docs

## Frontend


### Setup NextJS

NextJS akan dibuatkan folder khusus bernama `frontend`, semua file terkait halaman web html
, modul nodejs akan disini.

1. Buat folder baru didalam project

    ```bash =>
    mkdir frontend
    ```

2. Setup NextJS didalam folder frontend

    ```bash
    cd frontend
    npx create-next-app basic-nextjs --typescript
    ```

3. Jalankan development server dari **npm**
   
   ```bash
   npm run dev
   ```

   Server bisa diakses dengan alamat `http://localhost:3000`