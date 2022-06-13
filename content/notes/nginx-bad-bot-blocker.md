---
title: "Nginx Bad Bots Blocker"
date: 2022-06-13T15:48:03+07:00
draft: false
disquss: true
---

## Bagian 1: Instalasi 

1. Download `install-ngxblocker`
    
    ```bash
    sudo wget https://raw.githubusercontent.com/mitchellkrogza/nginx-ultimate-bad-bot-blocker/master/install-ngxblocker -O /usr/local/sbin/install-ngxblocker
    sudo chmod +x /usr/local/sbin/install-ngxblocker
    ```

2. Jalankan `install-ngxblocker` dengan mode DRY-MODE/DRY-RUN untuk melihat peubahan apa yang dibuat dan file apa saja yang didownload.
    
    ```bash
    cd /usr/local/sbin
    sudo ./install-ngxblocker
    ```
   Dengan DRY-MODE, script hanya melakukan simulasi setup. 
    

3. Jalankan `install-ngxblocker` dengan parameter `-x` untuk benar-benar mendownload file yang diperlukan.
    
    ```bash
    cd /usr/local/sbin
    sudo ./install-ngxblocker -x
    ```

    Script ini akan membuat folder `/etc/nginx/bots.d` dan mendownload file konfigurasi yang diperlukan ke folder tersebut. Juga akan mendownload file `setup-ngxblocker` dan `update-ngxblocker` ke folder `/usr/local/sbin`.

4. Ganti mode script setup dan update agar bisa dieksekusi mandiri.
    
    ```bash
    sudo chmod +x /usr/local/sbin/setup-ngxblocker
    sudo chmod +x /usr/local/sbin/update-ngxblocker
    ```

## Bagian 2: Setup

1. Jalankan `setup-ngxblocker` dengan mode DRY-MODE/DRY-RUN. Tidak ada perubahan dan file yang akan didownload.
    
    ```bash
    cd /usr/local/sbin/
    sudo ./setup-ngxblocker
    ```
    
    Script ini juga akan menambahkan IP server anda ke dalam `whitelist-ips.conf` pada `/etc/nginx/bots.d/whitelist-ips.conf`
    

2. Setup otomatis. Setup ini akan berhasil jika struktur folder konfigurasi anda terdapat `sites-available`. Jika tidak, lihat bagian **Setup manual**.

   * Jalankan `setup-ngxblocker` dengan parameter `-x`.

      Jika file konfigurasi anda di folder sites-available memiliki extensi `.conf` tambahkan parameter `-e conf`.

       ```bash
       cd /usr/local/sbin/
       sudo ./setup-ngxblocker -x -e conf
       ```
        
       Script ini akan menambahkan
        
       ```bash
       # Bad Bot Blocker
       include /etc/nginx/bots.d/ddos.conf;
       include /etc/nginx/bots.d/blockbots.conf;
       ```
          
       ke file konfigurasi `.conf` anda.
        
    
3. Setup manual.
   * Salin;
        
      ```bash
      # Bad Bot Blocker
      include /etc/nginx/bots.d/ddos.conf;
      include /etc/nginx/bots.d/blockbots.conf;
      ```
        
      ke file konfigurasi virtual host anda yang sudah ada di folder `conf.d`, misalnya `default.conf`. Saya menggunakan Nginx docker, file konfigurasi default adalah `/etc/nginx/conf.d/default.conf`
        
   * Tambahkan IP anda ke file `/etc/nginx/bots.d/whitelist-ips.conf`
   * Jika menggunakan docker, tambahkan juga IP host ke file `whitelist-ips.conf`
   * Jika Nginx disetup dibelakang router/proxy, tambahkan juga IP router/proxynya jika IP tersebut yang digunakan untuk mengakses Nginx.

1. Test validitas konfigurasi
    
    ```bash
    sudo nginx -t
    ```
    
    hasilnya harus;
    
    ```bash
    nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    nginx: configuration file /etc/nginx/nginx.conf test is successful
    ```
    
2. Reload/restart Nginx
    
    ```bash
    sudo nginx -t && sudo nginx -s reload
    ```
    
    atau;
    
    ```bash
    sudo service nginx restart
    ```
    

## Bagian 3: Auto-update, Konfigurasi Mandiri dan Test

1. Setup crontab untuk otomatis update blocker
    
    ```bash
    sudo crontab -e
    ```
    
    Update setiap jam 10 malam dan informasi update akan dikirim ke email;
    
    ```bash
    00 22 * * * sudo /usr/local/sbin/update-ngxblocker -e yourname@youremail.com
    ```
    
    Blocker akan mengupdate dirinya sendiri dan memangil ulang Nginx setelah versi terakhir file `globalblacklist.conf` selesai didownload.
    
2. Konfigurasi mandiri
    
    Lokasi file konfigurasi yang bisa disesuaikan mandiri;
    
    ```bash
    /etc/nginx/bots.d/whitelist-ips.conf
    /etc/nginx/bots.d/whitelist-domains.conf
    /etc/nginx/bots.d/blockbots.conf
    /etc/nginx/bots.d/blacklist-domains.conf
    /etc/nginx/bots.d/blacklist-user-agents.conf
    /etc/nginx/bots.d/blacklist-ips.conf
    /etc/nginx/bots.d/bad-referrer-words.conf
    /etc/nginx/bots.d/custom-bad-referrers.conf
    /etc/nginx/bots.d/ddos.conf
    ```
    

1. Testing
    
    ```bash
    curl -A "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.96 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)" -I http://yourdomain.com
    
    curl -A "Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)" -I http://yourdomain.com
    ```
    
    Harus mengembalikan respon **200 OK**
    
    ```bash
    curl -A "Xenu Link Sleuth/1.3.8" -I http://yourdomain.com
    
    curl -A "Mozilla/5.0 (compatible; AhrefsBot/5.2; +http://ahrefs.com/robot/)" -I http://yourdomain.com
    ```
    
    Harus mengembalikan salah satu pesan berikut;
    
    - curl: (52) Empty reply from server
    - curl: (56) TCP connection reset by peer
    - curl: (92) HTTP/2 stream 0 was not closed cleanly: PROTOCOL_ERROR (err 1)
    
    ```bash
    curl -I http://yourdomain.com -e http://100dollars-seo.com
    
    curl -I http://yourdomain.com -e http://zx6.ru
    ```
    
    Harus mengembalikan salah satu pesan berikut;
    
    - curl: (52) Empty reply from server
    - curl: (56) TCP connection reset by peer
    - curl: (92) HTTP/2 stream 0 was not closed cleanly: PROTOCOL_ERROR (err 1)
