function applySavedTheme() {
  const savedTheme = localStorage.getItem("theme");
  if (!savedTheme) return;

  document.body.classList.remove("theme-light", "theme-dark");
  document.body.classList.add(savedTheme);
}

function setupThemeToggle() {
  const toggleButton = document.getElementById("theme-toggle");
  if (!toggleButton) return;

  // IMPORTANT : empêcher d'ajouter l'événement plusieurs fois
  if (toggleButton.dataset.listenerAdded === "true") return;
  toggleButton.dataset.listenerAdded = "true";

  toggleButton.addEventListener("click", () => {
    const isLight = document.body.classList.contains("theme-light");
    const newTheme = isLight ? "theme-dark" : "theme-light";

    document.body.classList.remove("theme-light", "theme-dark");
    document.body.classList.add(newTheme);

    localStorage.setItem("theme", newTheme);
  });
}

// Hotwire Turbo events
document.addEventListener("turbo:load", () => {
  applySavedTheme();
  setupThemeToggle();
});

document.addEventListener("turbo:render", () => {
  applySavedTheme();
  setupThemeToggle();
});


/// EDIT: Le bouton est fonctionnel 100% du temps ///
/// Turbo peut faire bugger le bouton en rechargant le HTML ///
/// Ajout de SavedTheme pour recharger le thème choisit par l'utilisateur ///
/// lorsqu'il y a un changement de page ///
