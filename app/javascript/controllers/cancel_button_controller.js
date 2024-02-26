import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  connect() {
    const button = this.buttonTarget;
    const status = button.dataset.cancelButtonStatus;
    if (status === 'canceled') {
      button.disabled = true;
      this.updateButtonText(status);
      this.disableEditButton(button.dataset.cancelButtonId);
    } else {
      button.disabled = false;
      this.updateButtonText(status);
      this.enableEditButton(button.dataset.cancelButtonId);
    }
  }

  loadStatus(event) {
    event.preventDefault();
    const button = this.buttonTarget;
    const id = button.dataset.cancelButtonId;
    const status = button.dataset.cancelButtonStatus;
    if (status !== 'canceled') {
      button.dataset.cancelButtonStatus = 'canceled';
      this.updateButtonText('canceled');
      button.disabled = true;
      this.disableEditButton(id);
      fetch(`/bank_billets/${id}/cancel`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        }
      })
      .then(response => {
        if (response.status ===   204) {
          return {};
        } else if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        return response.text().then(text => text ? JSON.parse(text) : {});
      })
      .then(data => {
        console.log('Cancelamento realizado com sucesso:', data);
      })
      .catch(error => {
        console.error('Erro ao realizar o cancelamento:', error);
        button.dataset.cancelButtonStatus = status;
        this.updateButtonText(status);
        this.enableEditButton();
      });
    }
  }

  updateButtonText(status) {
    const button = this.buttonTarget;
    button.textContent = status === 'canceled' ? 'Cancelado' : 'Cancelar';
  }

  disableEditButton(bankBilletId) {
    const editButton = document.querySelector(`[data-bank-billet-id="${bankBilletId}"]`);
    if (editButton) {
      editButton.disabled = true;
    }
  }

  enableEditButton(bankBilletId) {
    const editButton = document.querySelector(`[data-bank-billet-id="${bankBilletId}"]`);
    if (editButton) {
      editButton.disabled = false;
    }
  }
}
