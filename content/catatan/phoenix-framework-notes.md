---
title: "Phoenix Framework Notes"
date: 2022-04-28T23:41:05+07:00
draft: true
toc: true
---

## Address already in use

```
$ mix phx.server

[error] Failed to start Ranch listener HelloWeb.Endpoint.HTTP in :ranch_tcp:listen([cacerts: :..., key: :..., cert: :..., ip: {127, 0, 0, 1}, port: 4000]) for reason :eaddrinuse (address already in use)
```

**Solusi**

Matikan proses yang sedang menggunakan port 4000

```bash
# Tampilkan proses

> netstat -ano | findstr :4000

TCP    127.0.0.1:4000         0.0.0.0:0              LISTENING       14468

# Matikan proses berdasarkan PID

> taskkill /F /PID 14468
```
