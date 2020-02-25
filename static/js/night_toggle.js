var toggle = document.getElementById("night-mode-toggle");
var currentMode = toggle.dataset.currentMode;
var nightTheme = document.getElementById("night-mode-theme");

toggle.addEventListener("click", () => {
  if (toggle.dataset.currentMode === "light") {
    setTheme("night");
  } else if (toggle.dataset.currentMode === "night") {
    setTheme("light");
  }
});

// the default theme is light
var savedTheme = localStorage.getItem("night-mode-storage") || "light";
setTheme(savedTheme);

function setTheme(mode) {
  localStorage.setItem("night-mode-storage", mode);

  if (mode === "night") {
    nightTheme.disabled = false;
    toggle.dataset.currentMode = "night";
    toggle.innerHTML = "Light";
  } else if (mode === "light") {
    nightTheme.disabled = true;
    toggle.dataset.currentMode = "light";
    toggle.innerHTML = "Night";
  }
}

