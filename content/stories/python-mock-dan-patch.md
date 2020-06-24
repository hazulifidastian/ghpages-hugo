---
title: "Python Mock & Patch"
date: 2020-06-24T12:11:00+07:00
draft: false
toc: true
disqus: true
tags: ["test", "python"]
---

### Mock os.environ

Mocking fungsi `os.environ` saat membaca variable environment.

```python
import os.environ
from unittest import mock

@mock.patch.dict(os.environ, {'KEY': 'Value'})
def test_foo():
    foo()
```
