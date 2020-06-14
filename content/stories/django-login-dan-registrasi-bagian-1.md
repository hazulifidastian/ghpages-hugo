---
title: "Django: Login dan Registrasi Bg.1"
date: 2020-06-13T04:55:23+07:00
draft: false
tags: ["python", "django"]
toc: true
disqus: true
description: Tutorial ini mengupas cara pembuatan registrasi dan login menggunakan framework Django.
---

Setelah mempraktekkan tutorial ini, anda akan bisa membuat sendiri fitur login dan registrasi pengguna menggunakan framework django.

Fitur login dan registrasi penguna disini saya bagi menjadi dua. Pertama, pengguna bisa melakukan registrasi dan login menggunakan akun email dan sosial media. Disini saya menggunakan akun google/gmail, facebook, dan twitter. Kemudian kedua, pengguna bisa registrasi manual seperti biasa menggunakan form berisi username dan password.

Artikel pertama ini, kita akan membahas mulai pemasangan django, pembuatan user dan integrasi dengan akun google.

## Dependency Management

Sebelum membuat proyek django, kita perlu memasang paket django terlebih dahulu.

Saya menggunakan [poetry](https://python-poetry.org/) sebagai _dependency management_. Selain poetry, anda bisa menggunakan `pip` atau `pipenv`.

```bash
mkdir django-login-register
cd django-login-register
poetry init
```

Perintah `poetry init` membantu anda membuat file **pyproject.toml**. Saat menjalankan perintah tersebut diterminal akan muncul beberapa pertanyaan yang perlu anda isi.

Untuk beberapa pertanyaan, jawab dengan isian seperti dibawah ini.

```bash
Compatible Python versions [^3.7]:  ~=3.7

Would you like to define your main dependencies interactively? (yes/no) [yes] no
Would you like to define your development dependencies interactively? (yes/no) [yes] no
```

Buka file **pyproject.toml**, dan tambahkan paket django seperti dibawah ini.

```toml
[tool.poetry.dependencies]
python = "~=3.7"
django = "~=2.2"
```

Selanjutnya kita bisa perintahkan poetry untuk mengunduh dan memasang paket yang sudah didefiniskan pada file pyproject.toml.

```bash
poetry install
```

Poetry akan memasang paket django dengan versi `2.2.*`. Pada saat tutorial ini saya buat, paket django yang terpasang adalah versi `2.2.13`.

Kenapa menggunakan paket django versi `2.2.0`?

Paket tersebut merupakan versi stabil dan LTS (Long Time Support). Artinya versi tersebut akan didukung untuk waktu yang lama. Bugs pada kode, dan kelemahan keamanan akan terus diperbaiki hingga waktu dukungannya telah selesai.

## Membuat Proyek Django

Untuk membuat proyek django menggunakan paket django yang kita pasang sebelumnya, masuk terlebih dahulu ke _virtual enviroment_ yang sudah disiapkan oleh poetry.

```bash
poetry shell
```

Didalam _virtual environment_, aplikasi dan paket pada proyek anda terisolasi hanya didirektori tersebut. Versi python beserta paketnya bisa terpisah dengan versi python yang ada pada sistem operasi.

Lanjutkan dengan membuat proyek django.

```bash
django-admin startproject django_login_register .
```

Jangan ketinggalan tanda titik pada akhir perintah diatas! `django-admin startproject` akan membuat proyek django dan menginisiasi struktur file dan direktori proyek.

Perintah `tree` pada linux akan menampilkan struktur file dan direktori.

```bash
tree
.
├── django_login_register
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── manage.py
├── poetry.lock
└── pyproject.toml
```

## Custom User

Saya merekomendasikan untuk membuat model user sendiri, tidak menggunakan model user standar dari django.

Dengan membuat model sendiri, kita bisa lebih leluasa nantinya untuk melakukan penyesuaian data pada user. Model user standar django tidak bisa dirubah-rubah.

Untuk menambah data user, kita perlu membuat model baru tersendiri. Dan harus menambahkan relasi ke model standar user dari model baru tersebut.

Misalnya, untuk menambahkan data alamat user kita harus membuat model `Profile` yang berisi _field_ alamat. Model tersebut juga harus memiliki relasi `onetoone` dengan model `User`.

Lumayan repot.

### Membuat App users

Untuk membuat model user sendiri, kita bisa mulai dengan membuat `app` django terlebih dahulu.

```bash
# Pastikan anda sudah masuk ke virtual enviroment poetry.
# Jika belum, ketik "poetry shell" terlebih dahulu

./manage.py startapp users
```

Django akan membuat struktur direktori baru dengan nama users.

```bash
tree
.
├── users
│   ├── admin.py
│   ├── apps.py
│   ├── __init__.py
│   ├── migrations
│   │   └── __init__.py
│   ├── models.py
│   ├── tests.py
│   └── views.py
├── django_login_register
│   ├── ...
```

### Membuat model CustomUser

Kita akan merubah file **models.py**, dan membuat model user baru.

```python
from django.db import models
from django.contrib.auth.base_user import BaseUserManager
from django.contrib.auth.models import AbstractUser
from django.utils.translation import ugettext_lazy as _


class CustomUserManager(BaseUserManager):
    """
    Menangani perubahan dihapusnya field username
    pada model CustomUser
    """

    def create_user(self, email, password, **extra_fields):
        """
        Buat dan simpan user dengan email dan password
        """
        if not email:
            raise ValueError(_('The Email must be set'))
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save()
        return user

    def create_superuser(self, email, password, **extra_fields):
        """
        Buat dan simpan superuser dengan email dan password
        """
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_active', True)

        if extra_fields.get('is_staff') is not True:
            raise ValueError(_('Superuser must have is_staff=True.'))
        if extra_fields.get('is_superuser') is not True:
            raise ValueError(_('Superuser must have is_superuser=True.'))
        return self.create_user(email, password, **extra_fields)


class CustomUser(AbstractUser):
    "Custom user"
    username = None
    email = models.EmailField(_("email address"), unique=True)
    alamat = models.CharField(blank=True, max_length=255)

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = []

    objects = CustomUserManager()

    def __str__(self):
        return self.email
```

Kode diatas akan,

- Membuat model `CustomUser`
- Menghilangkan _field_ `username`
- Membuat _field_ `email` menjadi unik
- Menjadikan _field_ `email` sebagai `username`
- Menambahkan `CustomUserManager` pada model. Manager ini untuk menangani perubahan pada standar user django. Standarnya django menggunakan field username sebagai field utama untuk login. Pada model CustomUser ini, kita menghilangkan field username. Jika tidak ditambahkan CustomUserManage, aplikasi akan memunculkan pesan error.

Agar model `CustomUser` bisa tampil pada halaman admin django, tambahkan
kode berikut pada file **admin.py**,

```python
from django.contrib import admin
from users.models import CustomUser


class CustomUserAdmin(admin.ModelAdmin):
    "Admin class for CustomUserAdmin"
    model = CustomUser


admin.site.register(CustomUser, CustomUserAdmin)
```

Kemudian tambahkan konfigurasi standar model user pada file **settings.py** dan daftarkan app users ke dalam variable `INSTALLED_APPS`.

```python
INSTALLED_APPS = [
    ...
    "users",
]

AUTH_USER_MODEL = "users.CustomUser"
```

### Migrasi

Fitur migrasi pada django saat dijalankan pertama kali akan membuat database beserta tabel-tabel yang dibutuhkan.

```bash
./manage.py makemigrations
./manage.py migrate
```

Jika kita tidak menentukan pilihan database, django akan menggunakan sqlite sebagai databasenya.

Model CustomUser diatas akan menjadi tabel sendiri pada database. Dan tabel ini akan dijadikan sebagaia tempat penyimpanan data pengguna aplikasi.

### Menjalankan Django

Sekarang anda bisa menjalankan django dari terminal dan menampilkan aplikasi pada browser.

```bash
./manage.py runserver
```

Buka peramban web, dan ketikkan `http://127.0.0.1:8000`.

{{< figure src="/images/django-login-register/django-homepage.png" caption="Halaman Depan Django" alt="Halaman Depan Django" >}}

### Membuat superuser

Perintah dibawah akan memandu anda untuk membuat superuser. Superuser adalah akun yang digunakan untuk login ke halaman admin (`http://127.0.0.1/admin/`)

```bash
./manage.py createsuperuser
```

## Manajemen User Dengan django-allauth

Django memang memiliki fitur untuk mempermudah perbuatan database user, tapi tidak memiliki fitur untuk manajemen login dan registrasi.

Kita akan menggunakan paket [django-allauth](https://github.com/pennersr/django-allauth) untuk memenuhi kebutuhan tersebut.

Ada banyak fitur yang secara gratis kita dapatkan jika kita menggunakan paket ini. Antara lain adalah:

- Registrasi manual dan akun media sosial.
- Bisa terhubung dengan lebih dari satu akun media sosial
- Bisa mendaftarkan banyak email untuk satu akun
- Lupa password
- Verifikasi Email

Provider yang terhubung dengan django-allauth sangat banyak. Daftar nya bisa dilihat [supported providers](https://django-allauth.readthedocs.io/en/latest/overview.html#supported-providers).

### Pemasangan django-allauth

```bash
poetry add django-allauth
```

### Konfigurasi django-allauth

Konfigurasi file **settings.py**,

```python
INSTALLED_APPS = [
    ...
    # App ini dibutuhkan
    'django.contrib.auth',
    'django.contrib.messages',
    'django.contrib.sites',

    'allauth',
    'allauth.account',
    'allauth.socialaccount',

    # provider akun yang dibutuhkan:
    'allauth.socialaccount.providers.facebook',
    'allauth.socialaccount.providers.google',
    'allauth.socialaccount.providers.twitter',
    ...
]

TEMPLATES = [{
    ...
    'OPTIONS': {
        'context_processors': [
            ...
            # `allauth` membutuhkan setting ini pada django
            'django.template.context_processors.request',
        ],
    },
}]

AUTHENTICATION_BACKENDS = [
    # Login menggunakan django admin
    'django.contrib.auth.backends.ModelBackend',
    # Metode login dari `allauth`
    'allauth.account.auth_backends.AuthenticationBackend',
]

SITE_ID = 1

# Setting provider, dibahas pada sesi tersendiri
SOCIALACCOUNT_PROVIDERS = {
    'google': {'APP': {'client_id': '...', 'secret': '...', 'key': '...'}},
    'twitter': {'APP': {'client_id': '...', 'secret': '...', 'key': '...'}},
    'facebook': {'APP': {'client_id': '...', 'secret': '...', 'key': '...'}},
}

# Konfigurasi lebih lengkap bisa dilihat di https://django-allauth.readthedocs.io/en/latest/configuration.html
ACCOUNT_EMAIL_REQUIRED = True
ACCOUNT_UNIQUE_EMAIL = True

# Wajib diisi seperti ini, menyesuaikan
# dengan model CustomUser yang kita buat
# tanpa username
ACCOUNT_USER_MODEL_USERNAME_FIELD = None
ACCOUNT_USERNAME_REQUIRED = False

ACCOUNT_EMAIL_VERIFICATION = True
ACCOUNT_SIGNUP_PASSWORD_ENTER_TWICE = False
ACCOUNT_SESSION_REMEMBER = True
ACCOUNT_AUTHENTICATION_METHOD = 'email'

LOGIN_REDIRECT_URL = '/'
```

Pada file **urls.py**, kita akan mengarahkan path `/accounts/` untuk ditangani oleh django-allauth.

```python
urlpatterns = [
    ...
    path('accounts/', include('allauth.urls')),
    ...
]
```

### Migrasi

Setelah pemasangan dan konfigurasi selesai, jalankan perintah migrasi untuk penyesuaian database.

```bash
./manage.py migrate
```

### Url Baru

Saat ini aplikasi memiliki url baru yang diawali dengan `/accounts/...`. Penambahan `path('accounts/', include('allauth.urls'))` pada `urls.py` yang membuat aplikasi memiliki url baru.

Beberapa url yang bisa anda eksplorasi:

- `/accounts/login/`, untuk login
- `/accounts/signup/`, untuk registrasi
- `/accounts/password/reset/`, untuk setel ulang password

{{< figure src="/images/django-login-register/login.png" caption="Halaman Login" alt="Halaman Login" >}}

### Memasang Halaman Depan

Halaman depan akan kita isi dengan menu registrasi, login, logout dan informasi user yang sedang login.

Untuk itu, kita perlu memuat app baru dengan nama home.

```bash
./manage.py startapp home
```

Buka file **home/views.py**

```python
from django.views.generic import TemplateView


class IndexView(TemplateView):
    template_name = 'home/index.html'
```

Buat file **home/templates/home/index.html**, dan isikan dengan,

```django
{% extends 'base.html' %}

{% block content %}
    {% if request.user.is_authenticated %}
        Hai {{ request.user.email }}!
    {% else %}
        Tidak ada user yang login
    {% endif %}
{% endblock %}
```

Buka file **django-login-register/urls.py**

```python
...
from home.views import IndexView

urlpatterns = [
    path('', IndexView.as_view(), name='index'),
    ...
]
```

Tambahkan app home pada `INSTALLED_APPS` file **django-login-register/settings.py**

```python
INSTALLED_APPS = [
    ...
    'home',
    ...
]
```

Buka peramban dan ketikkan, `http://127.0.0.1:8000`.

### Integrasi Dengan Akun Google/Gmail

#### Registrasi App

Google menyediakan API agar kita bisa berinteraksi dengan fitur akun mereka. Agar bisa terintegrasi dengan aplikasi terlebih dahulu kita perlu mendaftarkan app digoogle. Dari app yang kita buat inilah kita akan mendapatkan _key_ dan _secret_.

Untuk mendaftarkan app, kita perlu mengikuti prosedur yang sudah ditentukan oleh google.

Untuk memulainya silahkan buka [Google Developer Console](https://console.developers.google.com/).

**Create project**

- Klik daftar project, menu kotak kiri atas disamping logo Google APIs
- Klik **NEW PROJECT**
- Isi dengan nama project
- Klik Create

{{< figure src="/images/django-login-register/google-01-create-project.png" caption="Create Project" alt="Create Project" >}}

**Lengkapi OAuth consent screen**

- Klik menu **OAuth consent screen** dipanel bagian kiri
- Lengkapi bidang isian Application name: django-login-register
- Klik Save

{{< figure src="/images/django-login-register/google-02-oauth-consent.png" caption="OAuth Consent" alt="OAuth Consent" >}}

**Buat OAuth Client ID**

- Klik menu **Credentials** dipanel bagian kiri
- Lengkapi bidang isian dengan:
  - Aplication type: Web application
  - Authorized Javascript Origin: http://127.0.0.1:8000
  - Authorized redirect URIs: http://127.0.0.1:8000/accounts/google/login/callback/
  - Klik Save

{{< figure src="/images/django-login-register/google-03-client.png" caption="Create OAuth Client ID" alt="Create OAuth Client ID" >}}

#### Konfigurasi Django

File **settings.py**

```python
SOCIALACCOUNT_PROVIDERS = {
    'google': {
        'APP': {
            'client_id': 'isi dengan client id yang anda dapatkan',
            'secret': 'isi dengan secret yang anda dapatkan',
            'key': '',  # Kosongkan
        }
    },
    ...
}
```

<!-- ### Integrasi Dengan Akun Twitter -->

<!-- !!! Catatan: saya masih belum berhasil dengan twitter. Nanti akan saya update tulisan ini jika ada perkembangan. -->

<!-- Agar bisa terintegrasi dengan twitter anda harus memiliki akun twitter terlebih dahulu. Dengan akun tersebut, anda bisa membuat app twitter melalui: -->

<!-- Lebih lengkapnya bisa dipelajari disini https://django-allauth.readthedocs.io/en/latest/providers.html#twitter. -->

<!-- ### Integrasi Dengan Akun Facebook -->

<!-- Lebih lengkapnya bisa dipelajari disini https://django-allauth.readthedocs.io/en/latest/providers.html#facebook -->

<!-- Lebih praktis ikuti tutorial disini https://www.digitalocean.com/community/tutorials/django-authentication-with-facebook-instagram-and-linkedin#step-2-%E2%80%94-facebook-authentication -->

<!-- Sebagai tambahan, saya menambahkan paket `django-sslserver` agar bisa berinteraksi dengan server facebook tanpa error. Facebook mengharuskan client untuk menggunakan ssl/https. -->

<!-- ```bash -->
<!-- poetry add django-sslserver -->
<!-- ``` -->

### Uji Coba Registrasi dan Login

Setelah akun terintegrasi, kita lakukan uji coba registrasi dan login untuk memastikan keberhasilannya.

- Buka halaman registrasi `http://127.0.0.1:8000/accounts/social/signup/`
- Klik menu **Google**
- Pilih akun atau login dengan akun google anda
- Jika berhasil, aplikasi akan mengarahkan anda ke halaman depan aplikasi kita. Dan menampilkan email dari akun google yang kita gunakan untuk registrasi.

<!-- ## Fitur Lain django-allauth -->

<!-- ### Registrasi Manual -->

<!-- #### Konfigurasi Email Backend -->

<!-- #### Registrasi -->

<!-- #### Aktivasi Email -->

<!-- ### Login Manual -->

<!-- ### Menghubungkan Akun Manual Dengan Sosial -->

## Kesimpulan

Django memiliki fitur untuk menyimpan data user, namun tidak memiliki fitur untuk menangani proses login dan registrasi. Dengan paket django-allauth kita bisa memenuhi kebutuhan ini.

Dengan django-allauth kita tidak hanya bisa terhubung dengan akun google saja, namun juga bisa terhubung ke banyak provider lainnya. Tapi masing-masing provider memiliki prosedur yang berbeda, kita perlu mengkonfigurasinya satu persatu.

## Referensi

1. [How to Use Email as Username for Django Authentication](https://tech.serhatteker.com/post/2020-01/email-as-username-django/)
2. [Django Log In with Email not Username](https://wsvincent.com/django-login-with-email-not-username/)
3. [Dokumentasi django-allauth](https://django-allauth.readthedocs.io/en/latest/overview.html)

```

```
