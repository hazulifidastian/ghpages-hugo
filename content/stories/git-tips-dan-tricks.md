---
title: "Git Tips dan Tricks"
date: 2020-06-24T16:22:19+07:00
draft: false
toc: true
disqus: true
tags: ["git"]
---

### Caching Password

```bash
git config --global credential.helper cache
git push origin master
```

Username dan password akan dicache, `git push` selanjutnya tidak akan diminta lagi.

Referensi: [Caching your GitHub password in Git](https://help.github.com/en/github/using-git/caching-your-github-password-in-git#platform-linux)
