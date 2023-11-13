---
title: "Ubuntu Linux Notes"
date: 2022-06-08T07:13:01+07:00
draft: false
tags: ["ubuntu", "linux", "notes"]
---

### Timezone

* Show Timezone:

  ```bash
  timedatectl
  ```

* List Timezone:

  ```bash
  timedatectl list-timezones
  ```

* Set Timezone:

  ```bash
  timedatectl set-timezone Asia/Jakarta
  ```

### Add sudo user

* Tambah user
  ```
  sudo adduser <username>
  ```
* Tambah ke group `sudo`
  ```
  sudo adduser <username> sudo
  ```
* verifikasi
  ```
  id <username>
  ```

### Change password

* Ganti password user
  ```
  sudo passwd <username>
  ```
* Delete password
  ```
  sudo passwd --delete <username>
  ```
* Force expire password
  ```
  sudo passwd --expire <username>
  ```
* Lock user
  ```
  sudo passwd --lock <username>
  ```
* Unlock user
  ```
  sudo passwd --unlock <username>
  ```
