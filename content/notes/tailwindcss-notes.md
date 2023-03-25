---
title: "Tailwindcss Notes"
date: 2022-06-15T15:25:46+07:00
draft: true
---

### Install tailwindcss

Instalasi dan inisiasi

```bash
npm init -y

npm install -D tailwindcss
npx tailwindcss init

# Tambahkan folder src dan file didalamya

mkdir src
touch src/input.css
touch src/index.html
```

Edit file `tailwind.config.js`

```js
module.exports = {
  content: ["./src/**/*.{html,js}"],
  theme: {
    extend: {},
  },
  plugins: [],
}
```

Edit file `src/input.css`

```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

Jalankan tailwindcss

```bash
npx tailwindcss -i ./src/input.css -o ./dist/output.css --watch
```

Edit file `src/index.html`

```html
<!doctype html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="/dist/output.css" rel="stylesheet">
</head>
<body>
  <h1 class="text-3xl font-bold underline">
    Hello world!
  </h1>
</body>
</html>
```

### Install @tailwindtyphograpy

Instalasi

```bash
npm install -D @tailwindcss/typography
```

Edit file tailwind.config.js

```js
module.exports = {
  theme: {
    // ...
  },
  plugins: [
    require('@tailwindcss/typography'),
    // ...
  ],
}
```


### Install daisyui

Instalasi

```bash
npm i daisyui
```

Edit file `tailwind.config.js`

```js
module.exports = {
  theme: {
    // ...
  },
  plugins: [
    require("daisyui"),
    // ...
  ],
}
```

### Centering horizontal and vertical
