// chat_focus.js
document.addEventListener("turbo:load", () => {
  const container = document.getElementById("new_message_container");
  if (!container) return;

  const setFocus = () => {
    const input = document.getElementById("chat_input");
    if (input) input.focus();
  };

  // Focus initial
  setFocus();

  // Observer le conteneur pour détecter tout nouvel input ajouté par Turbo
  const observer = new MutationObserver(() => {
    setFocus();
  });

  observer.observe(container, { childList: true, subtree: true });

  // Aussi focus après chaque submit Turbo
  container.addEventListener("turbo:submit-end", () => {
    setTimeout(setFocus, 50);
  });
});
