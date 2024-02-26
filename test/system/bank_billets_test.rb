require "application_system_test_case"

class BankBilletsTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit bank_billets_url
    assert_selector "h1", text: "Boletos Bancários"
    assert_selector "table"
  end

  test "creating a Bank billet" do
    visit new_bank_billet_url
    fill_in "Valor", with: 100
    fill_in "Nome", with: "John Doe"
    fill_in "CNPJ/CPF", with: "16.974.923/0001-84"
    fill_in "Endereço", with: "Rua das Flores, 123"
    fill_in "Cidade", with: "São Paulo"
    fill_in "Estado", with: "SP"
    fill_in "CEP", with: "12345-678"
    fill_in "Bairro", with: "Centro"
    click_on "Criar Boleto"
  end

  test "updating a Bank billet" do
    visit bank_billets_url
    click_on "Editar", match: :first
    fill_in "Valor", with: 200
    click_on "Editar Boleto"
  end

  test "destroying a Bank billet" do
    visit bank_billets_url
    click_on "Cancelar", match: :first
  end

  test "showing a Bank billet" do
    visit bank_billets_url
    click_on "Ver", match: :first
    assert_selector "h1", text: "Boleto Bancário"
  end
end
