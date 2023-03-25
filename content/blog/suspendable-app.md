---
title: "Suspendable App"
date: 2020-03-02T06:25:49+07:00
draft: false
toc: true
tags: ["python", "concurency"]
description: Tulisan ini membahas cara melakukan suspend (menghentikan sementara) dan resume (melanjutkan kembali) aplikasi menggunakan python. Perintahnya ditrigger menggunakan shortcut pada keyboard.
disqus: true
---

Saya akan membagi aplikasi menjadi dua bagian. Pertama adalah bagian yang terus-menerus memantau input yang diberikan user melalui keyboard. Bagian ini akan aktif bersamaan dengan berjalannya aplikasi. Saya akan membuat fungsi yang merespon terhadap kombinasi shortcut keyboard tertentu.

Kedua adalah bagian yang menjalankan pekerjaan utama dalam aplikasi. Bagian ini bisa dikontrol, suspend (ditunda pekerjaannya), resume (dilanjutkan kembali) dan dihentikan.

Error yang terjadi dibagian kedua tidak boleh mempengaruhi bagian pertama. Dan bagian pertama memiliki kontrol penuh terhadap bagian kedua.

Dengan kebutuhan seperti diatas, saya mencoba membuat dua prototipe menggunakan fitur konkurensi pada python.

Kenapa harus konkurensi? Karena dua bagian yang dibutuhkan aplikasi diatas harus berjalan _bersamaan_. Input keyboard dari user harus terus bisa dipantau secara realtime. Kerja utama aplikasi juga tidak boleh terganggu.

Dengan cara sekuens, kita tidak bisa mendapatkan hasil yang sama. Karena sekuens mengharuskan kita memilih salah satu bagian untuk dijalankan, dan membuat bagian yang lain harus menunggu yang sedang berjalan itu selesai.

## Package yang Dibutuhkan

Install package `pyinput` untuk menangani input dari user.

```bash
pip install pyinput
```

Sebelumnya saya mencoba package `curses`, yang ternyata kurang cocok dengan kebutuhan untuk prototipe ini. Sepertinya `curses` digunakan jika kita ingin membuat antar muka / user inteface dengan konsep _window_ diterminal.

## Keyboard Handler

### Kode

```python
from pynput import keyboard

def keyboard_handler(proc):
    def on_cp():
        # Perintah pause & resume

    def on_cq():
        # Perintah keluar
        return False

    listener = keyboard.GlobalHotKeys({'<ctrl>+p': on_cp, '<ctrl>+q': on_cq})
    listener.start()

```

### Breakdown

Saya mendefinisikan fungsi untuk menangani input dari user melalui keyboard.

#### Shortcut

```python
listener = keyboard.GlobalHotKeys({'<ctrl>+p': on_cp, '<ctrl>+q': on_cq})
```

Kode ini menetapkan shortcut, beserta fungsi untuk merespon shortcut tersebut.

- `Ctrl+p` akan memanggil fungsi `on_cp`. Didalamnya berisi perintah untuk menghentikan sementara dan melanjutkan kembali.
- `Ctrl+q` akan memanggil fungsi `on_cq`. Perintah untuk keluar dari thread atau process.

```python
listener.start()
```

Kode ini akan memulai pemantauan input keyboard keyboard dari user.

## Prototyping Menggunakan Thread

### Kode

```python
import threading
import time

from pynput import keyboard


class Worker(threading.Thread):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.event = threading.Event()
        self.event.set()
        self.__stop = False

    def run(self):
        while True:
            if self.__stop:
                break
            if self.event.is_set():
                # Your main code here
                self.work()
                time.sleep(1)

    def work(self):
        print('Working')

    def suspend(self):
        print('Suspending')
        self.event.clear()

    def resume(self):
        print('Resuming')
        self.event.set()

    def terminate(self):
        print('Terminate')
        self.__stop = True


def keyboard_handler(worker):
    def on_cp():
        worker.suspend() if worker.event.is_set() else worker.resume()

    def on_cq():
        worker.terminate()
        return False

    listener = keyboard.GlobalHotKeys({'<ctrl>+p': on_cp, '<ctrl>+q': on_cq})
    listener.start()


def main():
    worker = Worker(daemon=True)
    worker.start()

    keyboard_handler(worker)

    worker.join()


if __name__ == '__main__':
    main()
```

### Breakdown

#### Fungsi `main` dan objek `Worker`

Saat aplikasi pertama dijalankan saya membuat Thread baru yang terpisah dari proses utama. Thread baru ini membuat objek `Worker` yang akan mengeksekusi method `run()`. Dan mencetak tulisan "Working" secara terus menerus diterminal.

##### `threading.Event`

`Event` adalah kelas yang mengimplementasikan objek event. Event memanajemen _flag_ yang bernilai boolean. Dengan perantara method `set()`, `clear()`, dan `wait()`.

Pada saat inisiasi _flag_ bernilai `False`.

```python
def run(self):
    # ...
    if self.event.is_set():
        # Your main code here
        self.work()
```

Pada method `run()`, saya memberikan kondisi menggunakan objek event. Objek inilah yang nantinya akan kita kontrol. Dan nilainya menentukan apakah program di suspend, atau dijalankan.

Pada method `def __init__` di kelas `Worker` saya menjadikan flag objek event menjadi `True` saat diinstansiasi. Lihat perintah perintah `self.event.set()` dimethod tersebut.

#### Kontrol

```python
def suspend(self):
    self.event.clear()

def resume(self):
    self.event.set()

def terminate(self):
    self.__stop = True
```

Fungsi kontrol dilakukan dengan cara memanipulasi flag dari objek event.

Saat objek dibuat, flag pada objek event bernilai `True`. Ini berarti program dijalankan. Dimethod `suspend()`, program dihentikan sementara. Caranya merubah nilai flag pada objek event menjadi `False` menggunakan method `clear()`.

Method `resume()`, akan melanjutkan program dengan kembali memanggil method `set()` pada objek event.

Untuk menghentikan aktifitas pada thread, variabel `self.__stop` di set menjadi `True`.

### Catatan

Mekanisme pada `Thread` _tidaklah benar-benar mensuspend_ program.

```python
def run(self):
    while True:
        if self.event.is_set():
            self.work()
```

Dia hanya melewatkan eksekusi saat disuspend (flag event bernilai `False`).

Sejauh yang saya pahami, saya belum menemukan cara untuk benar-benar men-suspend sebuah `Thread`.

## Prototyping Menggunakan Process

### Kode

```python
import os
import signal
import time
from multiprocessing import Process

from pynput import keyboard


def worker():
    while True:
        print('Working')
        time.sleep(1)


def keyboard_handler(proc):
    pause = False

    def suspend():
        os.kill(proc.pid, signal.SIGSTOP)

    def resume():
        os.kill(proc.pid, signal.SIGCONT)

    def quit():
        proc.terminate()

    def on_cp():
        nonlocal pause
        if not pause:
            print('Suspending')
            suspend()
            pause = True
        else:
            print('Suspending')
            resume()
            pause = False

    def on_cq():
        print('Terminating')
        if pause:
            resume()
        quit()
        return False

    listener = keyboard.GlobalHotKeys({'<ctrl>+p': on_cp, '<ctrl>+q': on_cq})
    listener.start()


def main():
    proc = Process(target=worker, daemon=True)
    proc.start()

    keyboard_handler(proc)

    proc.join()


if __name__ == '__main__':
    main()
```

### Breakdown

#### Fungsi `main` dan `worker`

Disini saya membuat proses (`Process`) baru yang terpisah dari proses utama. Proses baru ini mengeksekusi fungsi `worker` yang akan mencetak tulisan "Working" secara terus menerus diterminal.

`proc.start()` akan memulai proses, dan `proc.join()` akan menunggu hingga proses selesai dijalankan. Tentunya proses selesai dijalankan jika kita perintahkan untuk berhenti menggunakan shortcut yang dihandle didalam fungsi `keyboard_handler(proc)`.

#### Fungsi Kontrol

```python
def suspend():
    os.kill(proc.pid, signal.SIGSTOP)

def resume():
    os.kill(proc.pid, signal.SIGCONT)

def quit():
    proc.terminate()
```

Saya mengendalikan proses dengan mengirimkan signal tertentu pada proses. `SIGSTOP` untuk menghentikan sementara proses, dan `SIGCONT` untuk melanjutkan kembali proses.

Kita bisa menghentikan proses dengan menggunakan method `proc.terminate()`. `terminate()` akan menghentikan proses dan melanjutkan eksekusi ke method `proc.join()`. Kemudian keseluruhan aplikasi akan berhenti.
