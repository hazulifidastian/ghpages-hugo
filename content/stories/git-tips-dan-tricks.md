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

### Melihat Revisi Commit

Melihat revisi commit pada log.

```bash
# Menggunakan range id commit.
git log --oneline 6ff1760..05474ff

# Menggunakan range nama branch.
git log --oneline master..origin/master
```

Referensi:

- [git-log](https://git-scm.com/docs/git-log)
- [gitrevision](https://git-scm.com/docs/gitrevisions)

### Melihat Revisi Kode

Melihat revisi kode.

```bash
# Menggunakan range id commit.
git diff 6ff1760..05474ff

# Menggunakan range nama branch.
git diff master..origin/master
```

Referensi:

- [git-diff](https://git-scm.com/docs/git-diff)
- [gitrevision](https://git-scm.com/docs/gitrevisions)
