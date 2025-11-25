// theme_toggle.js

function setupThemeToggle() {
  const toggleButton = document.getElementById("theme-toggle");
  const body = document.body;

  if (!toggleButton) return;

  toggleButton.addEventListener("click", () => {
    const isLight = body.classList.contains("theme-light");

    body.classList.toggle("theme-light", !isLight);
    body.classList.toggle("theme-dark", isLight);

    toggleButton.textContent = isLight ? "Light" : "Dark";
  });
}

document.addEventListener("turbo:load", setupThemeToggle);
document.addEventListener("turbo:render", setupThemeToggle);
