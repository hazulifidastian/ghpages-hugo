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

### Mocking time.sleep

Patch menggunakan decorator.

```python
from unittest import mock
from unittest import TestCase

class TestClass(TestCase):
    @mock.patch('time.sleep', return_value=None)
    def test_func_with_time(self, patched_time_sleep):
        func_with_time()

        # Harus dipanggil 1 kali
        self.assertEqual(1, patched_time_sleep.call_count)
```

Patch menggunakan context manager `with`.

```python
from unittest import mock
from unittest import TestCase


class TestClass(TestCase):
    def test_func_with_time(self):
        with mock.patch('time.sleep', return_value=None) as patched_time_sleep:
            func_with_time()

        # Harus dipanggil 1 kali
        self.assertEqual(1, patched_time_sleep.call_count)
```

**Referensi**: [How to stub time.sleep() in Python unit testing](https://stackoverflow.com/questions/22836874/how-to-stub-time-sleep-in-python-unit-testing)

### Referensi

- https://stackoverflow.com/questions/3459287/whats-the-difference-between-a-mock-stub
