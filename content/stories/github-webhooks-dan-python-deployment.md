---
title: "GitHub Webhooks & Python Deployment"
date: 2020-06-22T22:58:05+07:00
draft: false
disqus: true
tags: ["deployment", "python"]
toc: true
description: "Saya akan membahas cara menangani GitHub webhooks menggunakan server python. Apa yang saya tulis disini adalah contoh sederhana, tanpa menggunakan web framework apapun. Hanya mengandalkan library yang sudah disediakan oleh python"
---

## Deskripsi Masalah

Seorang developer memiliki aplikasi yang sudah ditahap production. Live, sudah bisa diakses menggunakan internet. Aplikasinya dibangun menggunakan web framework dengan bahasa pemrograman python.

Pada server, developer menggunakan docker sebagai solusi pengepakan aplikasi. Kode disalin ke dalam sebuah image menjadi satu paket dengan sistem operasi didalam container.

Proses deployment yang berjalan sekarang menggunakan cara:

- Aplikasi rsync untuk memperbarui kode yang ada pada server
- Aplikasi remote ssh untuk mengontrol server
- Menjalankan perintah pada server untuk memperbarui docker container
- Menjalankan perintah pada server untuk migrasi database

Prosesnya masih dilakukan secara manual. Jika dalam dalam sehari banyak dilakukan deployment, maka berulangkali juga proses diatas dilakukan.

Proses diatas sebenarnya masih bisa disederhanakan. Dengan membuat beberapa script diserver, beberapa perintah pembaruan server bisa dihemat menjadi satu saja. Namun tetap masih diperlukan remote ssh untuk mengeksekusi script tersebut.

Bisakah proses deployment disederhanakan, tanpa harus melakukan satupun proses diatas? Inilah tujuan tulisan ini dibuat.

## GitHub Webhooks

Sebagian besar programmer saat ini pasti menggunakan version control system (VCS) dalam mengembangkan aplikasi. VCS ada beberapa macam, salah satunya adalah git yang sangat populer saat ini.

Git bisa digunakan secara lokal pada perangkat personal. Bisa juga menjadi server online. Pada server, git menjadi mirror bagi source code pada perangkat personal.

Salah satu server git yang banyak digunakan adalah [GitHub](https://github.com). GitHub menampung banyak source code dari seluruh dunia. Bisa digunakan gratis, dengan beberapa fitur yang dibatasi maupun berbayar. Source code bisa dibuka untuk umum (public), bisa juga disimpan untuk pribadi saja (private).

Webhooks adalah salah satu fitur pada GitHub. Menurut situs resminya webhooks adalah:

> Webhooks allow you to build or set up integrations, such as GitHub Apps or OAuth Apps, which subscribe to certain events on GitHub.com. When one of those events is triggered, we'll send a HTTP POST payload to the webhook's configured URL. Webhooks can be used to update an external issue tracker, trigger CI builds, update a backup mirror, or even deploy to your production server. You're only limited by your imagination.

Kurang lebih, webhooks adalah suatu fitur yang mengintegrasikan GitHub.com dengan aplikasi atau layanan diluarnya. Webhooks memicu sebuah event dan mengirimkan HTTP POST payload ke url yang telah dikonfigurasikan.

Fitur inilah yang akan digunakan untuk membuat otomatisasi proses deployment aplikasi.

Bagaimana memicu event pada webhooks?

Event pada webhooks dijelaskan pada [situs resminya](https://developer.github.com/webhooks/event-payloads/). Fokus tulisan ini ada pada dua event, yaitu:

1. Pushes, saat developer melakukan push source code ke GitHub
2. Pull Requests, saat developer melakukan aktifitas pull request

Push biasa digunakan untuk memperbarui source code yang ada pada server GitHub. Bisa sebagai backup, atau menjadi cara untuk mempublikasikan source code terbaru jika bekerja bersama tim.

Pull request adalah permintaan untuk menggabungkan source code. Hasil pengembangan source code diperangkat lokal dipush ke server sebagai branch sendiri. Selanjutnya pemilik branch membuat pull request (permintaan) untuk menggabungkan kodenya dengan branch utama. Kode pada branch tersebut akan direview, bisa diterima, diperbaiki atau bisa juga ditolak pull requestnya.

Kedua event tersebut yang akan dipantau dan diutilisasi untuk memicu proses deployment secara otomatis.

Standarnya, GitHub akan memicu event pada seluruh aktifitas yang terkait dengan dua event diatas. Push misalnya, semua push akan memicu event, tak peduli pada branch apapun. Tidak ada konfigurasi untuk memilih, misalnya hanya terpicu jika push pada branch master saja tidak pada branch yang lain. Begitu juga pull request, jika ada yang komentar pada thread pull request, ini juga akan memicu event pull request.

Tidak semua event yang dikirim oleh GitHub memicu proses deployment. Harus difilter. Namun filternya bukan pada GitHub, tapi pada aplikasi server yang menangani HTTP POST payload dari webhooks.

Saya spesifikasikan aktifitas yang bisa memicu proses deployment:

- Hanya push ke branch master
- Hanya merge pull request ke branch master

Dibawah ini adalah payload yang dikirimkan jika push ke branch master.

```json
{
  "ref": "refs/heads/master"
}
```

Sedangkan dibawah ini jika merge pull request ke branch master.

```json
{
  "action": "closed",
  "pull_request": {
    "merged": true,
    "base": {
      "ref": "master"
    }
  }
}
```

Aplikasi server yang menangani webhooks harus bisa memfilter dan memproses hanya dua payload diatas.

### Konfigurasi Webhooks

{{< figure src="/images/github-webhooks-dan-python-deployment/github-konfigurasi-webhooks.png" caption="Konfigurasi GitHub" alt="Konfigurasi GitHub" >}}

Konfigurasi webhooks pada halaman **Settings** pada repository. Kita bahas satu persatu bidang isian pada form konfigurasi webhooks diatas.

- Payload URL, url yang akan dikirimkan HTTP POST payload oleh GitHub
- Content type, tipe content berupa pilihan form html atau json
- Secret, teks yang akan dienkripsi dan dikirimkan ke server. Pada server nantinya akan divalidasi, untuk memastikan bahwa HTTP POST benar dikirimkan oleh GitHub webhooks.
- Let me select individual events, event yang akan memicu webhooks. Pilih hanya dua:
  {{< figure src="/images/github-webhooks-dan-python-deployment/github-pilihan-events.png" caption="Pilihan event" alt="Pilihan event" >}}
  - Pushes dan
  - Pull Requests

Simpan konfigurasi diatas. Selanjunya akan dibahas pemasangan server.

## Source Code Server

Server dibuat dengan python, tanpa menggunakan paket eksternal. Saya menggunakan python versi tiga.

Kode server ini sudah saya buat kan repository githubnya, tautannya ada diakhir tulisan.

### Entry Point

```python {hl_lines=[5]}
if __name__ == '__main__':
    from sys import argv

    if len(argv) == 2:
        run_server(port=int(argv[1]))
    else:
        run_server()
```

Kode diatas adalah entry point aplikasi. Menerima argument `port` yang akan digunakan oleh server.

### Kontrol Server

```python {hl_lines=[8]}
def run_server(server_class=HTTPServer, handler_class=ServerHandler, port=8080):
    """Run server"""
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print('Starting httpd...')
    print(f'Serving at port {port}\n')
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()
    print('Stopping httpd...')
```

Kode `httpd.serve_forever()` akan menjalankan server dan akan berhenti jika ada interupsi oleh keyboard.

### Request Handler

```python {hl_lines=[13, 32]}
class ServerHandler(BaseHTTPRequestHandler):
    def _set_response(self):
        """Set response"""
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def _send_response(self, message: str = '{"status": "failed"}'):
        """Send response"""
        self._set_response()
        self.wfile.write(message.encode('utf-8'))

    def do_POST(self):
        """Handle post request on /"""
        if not str(self.path).startswith('/payload'):
            self._send_response()
            return

        content_length = int(self.headers['Content-Length'])
        request_body = self.rfile.read(content_length)

        try:
            form = cgi.FieldStorage(
                BytesIO(request_body),
                headers=self.headers,
                environ={
                    'REQUEST_METHOD': 'POST',
                    'CONTENT_TYPE': self.headers['Content-Type'],
                },
            )
            payload_str = form.getvalue('payload')
            deploy(self.headers, request_body, payload_str)
        except Exception:
            self._send_response()
            return
        self._send_response('{"status": "success"}')
```

Bagian ini menangani request dari GitHub webhooks. Method `do_POST` akan dipanggil jika ada request POST yang masuk.

Handler ini akan menangani request yang memiliki uri **/payload**, selainnya tidak akan dilayani. Method ini akan mengirimkan pesan status dalam bentuk json.

```python
deploy(self.headers, request_body, payload_str)
```

Jika requst tidak ada masalah, maka baris kode ini akan memanggil fungsi `deploy`.

### Fungsi deploy()

```python
def deploy(headers: dict, request_body: bytes, payload_str: str):
    """Deploy"""
    if payload_str:
        payload = to_dict(payload_str)
        if payload:
            if is_secure(headers, request_body) and is_deployable(payload):
                run_command()
```

Fungsi `deploy` memiliki beberapa tugas:

- `to_dict()`, mengkonversi data payload berupa string berisi json menjadi tipe data dict
- `is_secure()`, menvalidasi teks rahasia terenkripsi. Yang diinputkan pada bidang isian **Secret** saat konfigurasi webhooks
- `is_deployable()`, melakukan filter payload dan menentukan aktifitas dari event yang bisa memicu proses deployment
- `run_command()`, akan menjalankan perintah deployment

### Fungsi is_secure()

```python {hl_lines=[5 8]}
def is_secure(headers: dict, request_body: bytes) -> bool:
    """Check secret key on header"""
    secret = environ['GITHUB_WEBHOOKS_SECRET']
    github_sig = headers.get('X-Hub-Signature', '')
    hex_sig = hmac.new(secret.encode(), request_body, hashlib.sha1).hexdigest()
    expected_sig = f'sha1={hex_sig}'

    if hmac.compare_digest(expected_sig, github_sig):
        return True
    return False
```

Pada header yang dikirimkan GitHub, disisipkan key `X-Hub-Signature` berisi nilai `sha1=SIGNATURE`. Signature merupakan text hasil enkripsi pada bidang isian **Secret** dan data payload.

```python
hex_sig = hmac.new(secret.encode(), request_body, hashlib.sha1).hexdigest()
```

kode ini membuat teks terenkripsi menggunakan teks rahasia yang digabungkan dengan request_body. Teks rahasia disisipkan melalui variabel environment `GITHUB_WEBHOOKS_SECRET`. Algoritma hash menggunakan **sha1**.

Cara menyisipkan variable environment saat menjalankan kode python:

```bash
GITHUB_WEBHOOKS_SECRET="THIS IS SECRET" python3 deploy_server.py 8080
```

### Fungsi is_deployable()

```python
def is_deployable(payload: dict) -> bool:
    """
    Cek is deployable. Push or merge pull request
    on branch master
    """
    is_push_to_master = payload.get('ref', '') == 'refs/heads/master'
    try:
        is_merge_pr_to_master = (
            payload['action'] == 'closed'
            and payload['pull_request']['merged'] is True
            and payload['pull_request']['base']['ref'] == 'master'
        )
    except KeyError:
        is_merge_pr_to_master = False

    if is_push_to_master:
        return True
    elif is_merge_pr_to_master:
        return True

    return False
```

Fungsi ini melakukan filter pada request yang masuk dengan membaca payload. Jika push dan merge pull request dilakukan pada branch master, maka fungsi akan mengembalikan nilai `True`.

### Fungsi run_command()

```python
def run_command():
    """Run command"""
    # git pull
    # rebuild docker
    # migration
    # dll
```

Fungsi `run_command()` berisi perintah untuk melakukan proses deployment. Perintah yang utama adalah `git pull` yang akan memperbarui source code pada aplikasi production.

Pastikan public key pada server production sudah terintegrasi dengan GitHub. Pelajari tutorial [ini](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).

### Menjalankan Server

Jalankan server menggunakan perintah dibawah ini. Terlihat dalam perintah ini disisipkan variabel environtment `GITHUB_WEBHOOKS_SECRET`.

```bash
GITHUB_WEBHOOKS_SECRET="THIS IS SECRET" python3 deploy_server.py 8080
```

Gunakan aplikasi ngrok untuk melakukan pengetesan. Ikuti tutorial pada halaman [Using Ngrok](https://developer.github.com/webhooks/configuring/#using-ngrok). Aplikasi ngrok bisa menjembatani antara GitHub webhooks dan perangkat lokal.

Saat production, harus online dan memiliki domain atau ip address agar github bisa mengirimkan HTTP POST payload. Gunakan aplikasi gunicorn untuk menjalankan server saat production.

### Kode Lengkap

Pada tulisan ini, saya tidak membahas semua kode. Kode lebih lengkap saya unggah pada github [koknggakada/deploy_server]().

## Kesimpulan

GitHub menyediakan fitur webhooks untuk mengintegrasikan source code pada server mereka agar otomatis bisa dideploy.

GitHub mengirimkan event pada setiap aktifitas yang berhubungan dengan event tersebut. Kode server yang harus melakukan filter, aktifitas apa yang bisa memicu deployment.

Proses deployment otomatis berjalan saat developer melakukan push atau merge pull request source codenya.
