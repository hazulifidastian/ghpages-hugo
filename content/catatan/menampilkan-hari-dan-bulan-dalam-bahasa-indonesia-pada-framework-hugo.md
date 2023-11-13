---
title: "Menampilkan Hari dan Bulan dalam Bahasa Indonesia pada Framework Hugo"
date: 2021-08-27T01:27:41+07:00
draft: false
description: "Cara menampilkan nama hari dan nama bulan dalam bahasa Indonesia pada framework Hugo"
tags: ["hugo"]
---

## File data

File **data/locale/id/day.yaml**.

```yaml
Monday: Senin
Tuesday: Selasa
Wednesday: Rabu
Thursday: Kamis
Friday: Jum'at
Saturday: Sabtu
Sunday: Minggu
```

File **data/locale/id/month.yaml**.

```yaml
- Januari
- Februari
- Maret
- April
- Mei
- Juni
- Juli
- Agustus
- September
- Oktober
- November
- Desember
```

## Konfigurasi

File **config.toml**

```toml
[params]
    defaultContentLanguage = "id"
```

## Template Partial

File **layouts/partials/date.html**.

```
{{ if eq .Context.Site.Params.defaultContentLanguage "en"}}
    {{ .Dt.Format "Monday, 02 Jan 2006" }}
{{ else }}
    {{ $days := index (index .Context.Site.Data.locale .Context.Site.Params.defaultContentLanguage).day }}
    {{ $months := index (index .Context.Site.Data.locale .Context.Site.Params.defaultContentLanguage).month }}

    {{ $dayName := index (index $days (string (time .Dt).Weekday)) }}
    {{ $monthName := index (index $months (sub .Dt.Month 1)) }}
    {{ $dayName }}, {{ .Dt.Day }} {{ $monthName }} {{ .Dt.Year }}
{{ end }}
```

## Cara Penggunaan

```
{{ partial "date.html" (dict "Context" . "Dt" .Date) }}
```