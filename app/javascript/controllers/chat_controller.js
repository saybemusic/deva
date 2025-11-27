import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages", "input"]

  connect() {
    console.log("chat controller CONNECTED")

    this.scrollToBottom()
    this.focusInput()

    // Observe tout changement dans la zone de messages
    if (this.hasMessagesTarget) {
      this.messagesObserver = new MutationObserver(() => {
        this.scrollToBottom()
      })
      this.messagesObserver.observe(this.messagesTarget, {
        childList: true,
        subtree: true
      })
    }

    // Observe tout changement dans le formulaire (ex : Turbo replace)
    if (this.hasInputTarget) {
      this.formObserver = new MutationObserver(() => {
        this.focusInput()
      })
      this.formObserver.observe(this.inputTarget.closest("div"), {
        childList: true,
        subtree: true
      })
    }
  }

  scrollToBottom() {
    if (!this.hasMessagesTarget) return
    setTimeout(() => {
      this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
      console.log("scrolled →", this.messagesTarget.scrollTop)
    }, 0)
  }

  focusInput() {
    if (!this.hasInputTarget) return
    setTimeout(() => {
      this.inputTarget.focus()
      console.log("focused input")
    }, 0)
  }
}
