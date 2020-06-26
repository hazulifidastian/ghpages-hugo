---
title: "Python Mock dan Stub"
date: 2020-06-24T12:11:00+07:00
draft: false
toc: true
disqus: true
tags: ["test", "python"]
---

### Mocking os.environ

Jika kode yang dites memanggil fungsi `os.environ`. Gunakan kode dibawah ini untuk melakukan mocking.

```python
import os.environ
from unittest import mock

@mock.patch.dict(os.environ, {'KEY': 'Value'})
def test_foo():
    foo()
```

### Referensi

- https://stackoverflow.com/questions/3459287/whats-the-difference-between-a-mock-stub
