---
title: "Docker Notes"
date: 2022-06-08T06:55:25+07:00
draft: true
tags: ["note", "docker"]
---

#### Akses variabel `env` pada container

Env variabel diambil dari mesin host. $HOME akan menampilkan home direktori pada mesin host bukan di container

```bash
docker exec -it [CONTAINER_NAME] /bin/bash -c "echo $HOME"
```

Env variabel diambil dari mesin container. Gunakan kutip satu untuk menghindari expresi diparsing pada mesin host

```bash
docker exec -it [CONTAINER_NAME] /bin/bash -c 'echo $HOME'  # $HOME pada container
```
