import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  connect() {
    this.applySavedTheme()
  }

  toggle() {
    const isLight = document.body.classList.contains("theme-light")
    const newTheme = isLight ? "theme-dark" : "theme-light"

    document.body.classList.remove("theme-light", "theme-dark")
    document.body.classList.add(newTheme)

    localStorage.setItem("theme", newTheme)
    this.updateButtonText()
  }

  applySavedTheme() {
    const savedTheme = localStorage.getItem("theme")
    if (savedTheme) {
      document.body.classList.remove("theme-light", "theme-dark")
      document.body.classList.add(savedTheme)
    }
    this.updateButtonText()
  }

  updateButtonText() {
    if (!this.hasButtonTarget) return
    const isLight = document.body.classList.contains("theme-light")
    this.buttonTarget.textContent = isLight ? "Light" : "Dark"
  }
}
