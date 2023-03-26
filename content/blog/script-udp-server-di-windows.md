---
title: "Script UDP Server Di Windows"
date: 2023-03-26T05:36:52+07:00
draft: false
tags: ["powershell", "udp"]
---

**Bind port**

Script ini akan membuka port UDP 8080 disemua network interface.

```powershell
$port = 8080
$endpoint = New-Object System.Net.IPEndPoint ([IPAddress]::Any, $port)
$socket = New-Object System.Net.Sockets.UdpClient $port
```


**Baca data**

Data yang diterima dalam bentuk byte dikonversi menjadi string.

```powershell
$contentByte = $socket.Receive([ref]$endpoint)
$enc = [system.Text.Encoding]::UTF8
$contentStr = $enc.GetString($contentByte)
```

**Token dan perintah**

Script ini saya gunakan untuk me-restart aplikasi lain. `$token` digunakan untuk pengaman, 
dan `$command` adalah perintah yang diinginkan. Data harus dikirim dengan format `TOKEN:COMMAND`. 

```powershell
$token, $command = $contentStr.split(':')
```

**Validasi token**

Token yang dikirim oleh client harus diacak menggunakan algoritma **SHA1**. Token memuat 
gabungan data token yang diset pada server dan tanggal saat mengirim perintah. 

Contoh `TOKEN_DARI_SERVER20230101`.

Script dibawah ini adalah pengaman untuk memvalidasi token yang dikirim oleh client.

```powershell
$dateText = Get-Date -Format "yyyyMMdd"

# token yang valid adalah gabungan hashed text dan tanggal sekarang
$tokenValidator = "6f797fcc675fe0f411ef56931936c63b8a026660"+ $dateText

$sha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider
$hashByteArray = $sha1.computeHash($enc.GetBytes($tokenValidator))

$validToken = ""
foreach ($byte in $hashByteArray) {
	$validToken += "{0:X2}".ToLower() -f $byte
}

if ($token -eq $validToken) {
	# token valid
} else {
    # token tidak valid
}
```

**Eksekusi perintah**

```powershell
if ($command -eq "RESTART") {
    # matikan service yang error
    taskkill /IM $targetProcessName /F

    # jalankan yang baru
    Start-Process $targetProcessPath
}
```

**Balas pesan**

Bagian ini untuk mengirimkan bytes "OK" ke client.

```powershell
$text = $enc.GetBytes("OK")
[void]$socket.Send($text, $text.Length, $endpoint)
```

**Referensi**

- Kode lengkap bisa dilihat di [https://gist.github.com/hazulifidastian/880279d67b71fd1b75ad7274bbfc213c](https://gist.github.com/hazulifidastian/880279d67b71fd1b75ad7274bbfc213c)