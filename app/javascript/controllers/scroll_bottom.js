
document.addEventListener("turbo:load", () => {
  const container = document.getElementById("messages_container");
  if (!container) return;

  container.scrollTop = container.scrollHeight;


  const observer = new MutationObserver(() => {
    container.scrollTop = container.scrollHeight;
  });
  observer.observe(container, { childList: true });
});
