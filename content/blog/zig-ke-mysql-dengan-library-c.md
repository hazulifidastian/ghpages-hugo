---
title: "Zig ke Mysql Dengan Library C"
date: 2023-03-25T22:14:30+07:00
draft: false
toc: true
tags: ["zig", "mysql"]
---

Ujicoba ini menggunakan zig versi 0.9.1 di platform Ubuntu 20.04 WSL 2 Windows.


## Persiapan

### Install MySQL Client Dev Library


```bash
$ apt install default-libmysqlclient-dev
```

Instalasi ini menghasilkan file header **mysql.h** pada folder **/usr/include/mysql** yang akan digunakan sebagai referensi oleh kode zig.

### Inisiasi Aplikasi

```bash
$ mkdir zig_mysql
$ cd zig_mysql
$ zig init-exe
```

Perintah `zig init-exe` untuk membuat aplikasi executable, sedangkan `zig init-lib` untuk membuat library.

## Kode

### Edit File `build.zig`

File **build.zig** tersedia setelah perintah `zig init-exe`.

```zig {hl_lines=[5]}
const exe = b.addExecutable("mysql", "src/main.zig");
exe.setTarget(target);
exe.setBuildMode(mode);

exe.addLibPath("/usr/lib/x86_64-linux-gnu");

exe.install();
```

Folder `/usr/lib/x86_64-linux-gnu` berisi library yang diinstall pada OS Ubuntu.

### Impor MySQL


**src/main.zig**.

```zig
const std = @import("std");
const mysql = @cImport(@cInclude("mysql.h"));
```

Sekarang semua fungsi yang ada pada file header **mysql.h** bisa diakses dari variabel `mysql`.


### Koneksi ke MySQL

```zig {hl_lines=[1,4,8]}
var con = mysql.mysql_init(null);

if (con == null) {
    std.debug.print("{s}", .{mysql.mysql_error(con)});
	exit(1);
}

if (mysql.mysql_real_connect(con, "127.0.0.1", "root", "root", null, 0, null, 0) == null) {
    finish_with_error(con);
}
```

Variabel `mysql.` sebagai prefix untuk memanggil fungsi yang ada pada **mysql.h**.

Fungsi `finish_with_error(con)` untuk menampilkan pesan error.

```zig
fn finish_with_error(con: *mysql.MYSQL) void {
    std.debug.print("{s}", .{mysql.mysql_error(con)});
    mysql.mysql_close(con);
    exit(1);
}
```

### Membuat Database

```zig {hl_lines=[2,6]}
fn create_db(con: *mysql.MYSQL) void {
    if (mysql.mysql_query(con, "DROP DATABASE IF EXISTS " ++ dbname) > 0) {
        finish_with_error(con);
    }

    if (mysql.mysql_query(con, "CREATE DATABASE IF NOT EXISTS " ++ dbname) > 0) {
        finish_with_error(con);
    }
}
```

Fungsi `mysql.mysql_query("...")` untuk mengirimkan perintah query MySQL.

### Membuat Tabel

```zig
fn create_table(con: *mysql.MYSQL) void {
    if (mysql.mysql_query(con, "CREATE TABLE cars(id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(255), price INT)") > 0) {
        finish_with_error(con);
    }
}
```

### Menambah Data

```zig
fn insert_data(con: *mysql.MYSQL) void {
    if (mysql.mysql_query(con, "INSERT INTO cars VALUES(1, 'Audi', 52642)") > 0) {
        finish_with_error(con);
    }

    if (mysql.mysql_query(con, "INSERT INTO cars VALUES(2, 'Mercedes', 57127)") > 0) {
        finish_with_error(con);
    }

    if (mysql.mysql_query(con, "INSERT INTO cars VALUES(3,'Skoda',9000)") > 0) {
        finish_with_error(con);
    }

    if (mysql.mysql_query(con, "INSERT INTO cars VALUES(4,'Volvo',29000)") > 0) {
        finish_with_error(con);
    }
}
```

### Mengambil Data

```zig {hl_lines=[2,6,12,14,"16-24"]}
fn retrieve_data(con: *mysql.MYSQL) void {
    if (mysql.mysql_query(con, "SELECT * FROM cars") > 0) {
        finish_with_error(con);
    }

    const result = mysql.mysql_store_result(con);

    if (result == null) {
        finish_with_error(con);
    }

    const num_fields = mysql.mysql_num_fields(result);

    var row = mysql.mysql_fetch_row(result);

    while (row != null) {
        var i: usize = 0;
        while (i < num_fields) : (i += 1) {
            std.debug.print("{s}  ", .{row[i]});
        }
        std.debug.print("\n", .{});

        row = mysql.mysql_fetch_row(result);
    }
}
```

- `mysql.mysql_query(con, "SELECT * FROM cars")` mengirimkan perintah untuk mengambil data
- `mysql.mysql_store_result(con)` menampung hasil query
- `mysql.mysql_num_fields(result)` jumlah fields/kolom data
- `mysql.mysql_fetch_row(result)` mengambil data per baris
- baris `while (row != null)` pengulangan untuk menampilkan data

## Compile and Run

```bash
$ zig build-exe src/main.zig -lmysqlclient -lc -I /usr/include/mysql
```

- `-lmysqlclient` adalah referensi library **libmysqlclient.so** pada folder **/usr/lib/x86_64-linux-gnu**
- `-lc` library c
- `-I /usr/include/mysql` folder pencarian include

Jalankan aplikasi setelah proses building selesai.

```bash
$ ./main
Mysql Client version 8.0.32

1  Audi  52642
2  Mercedes  57127
3  Skoda  9000
4  Volvo  29000
```

### Kode Lengkap

Kode lengkap ada di [https://github.com/hazulifidastian/zig-mysql](https://github.com/hazulifidastian/zig-mysql).


## Referensi

1. [Tutorial MySQL C API programming](https://zetcode.com/db/mysqlc/)
2. [Dokumentasi Zig](https://ziglang.org/documentation/0.9.1/)