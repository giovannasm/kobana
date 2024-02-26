require 'rails_helper'

RSpec.describe BankBillet, type: :model do # rubocop:disable Metrics/BlockLength
  let(:valid_attributes) do
    {
      customer_address: 'Rua da Casa',
      customer_neighborhood: 'Bairro',
      customer_zipcode: '01310100',
      customer_city_name: 'São Paulo',
      customer_state: 'SP',
      customer_cnpj_cpf: '16.974.923/0001-84',
      customer_person_name: 'Fulano da Silva',
      expire_at: '2025-12-31',
      amount: "100.00"
    }
  end

  describe '.all' do
    it 'fetches the bank billets from the external API', :vcr do
      bank_billets = BankBillet.all

      expect(bank_billets).to be_an(ActiveResource::Collection)
      expect(bank_billets.first).to be_a(BankBillet)
    end
  end

  describe '.create' do
    let(:bank_billet) { BankBillet.new(valid_attributes) }

    before do
      VCR.use_cassette('BankBillet/_create/bank_billet_create') do
        bank_billet.save
      end
    end

    it 'creates a bank billet' do
      expect(bank_billet).to be_persisted
      expect(bank_billet.customer_person_name).to eq('Fulano da Silva')
    end

    context 'when attributes are invalid' do
      let(:invalid_attributes) { valid_attributes.except(:amount) }
      let(:wrong_bank_billet) { BankBillet.new(invalid_attributes) }

      before do
        VCR.use_cassette('BankBillet/_create/bank_billet_create_invalid') do
          bank_billet.save
        end
      end

      it 'fails to create a bank billet without required attributes' do
        expect(wrong_bank_billet).not_to be_persisted
      end
    end
  end

  describe '.find' do
    it 'fetches the bank billet from the external API', :vcr do
      bank_billet_id = BankBillet.create(valid_attributes).id

      bank_billet = BankBillet.find(bank_billet_id)

      expect(bank_billet.id).to eq(bank_billet_id)
      expect(bank_billet.customer_person_name).to eq('Fulano da Silva')
    end
  end

  describe '.alter' do
    let(:bank_billet_id) { BankBillet.create(valid_attributes).id }

    it 'updates the bank billet', :vcr do
      body = {
        "amount" => "5000.00",
        "expire_at(1i)" => "2024",
        "expire_at(2i)" => "3",
        "expire_at(3i)" => "12"
      }

      response = BankBillet.alter(bank_billet_id, body)
      expect(response.code).to eq(204)

      bank_billet = BankBillet.find(bank_billet_id)
      expect(bank_billet.amount).to eq(5000.00)
    end
  end

  describe '.cancel' do
    it 'cancels the bank billet and confirms it was canceled', :vcr do
      bank_billet = BankBillet.create(valid_attributes)
      response = BankBillet.cancel(bank_billet.id)
      canceled_bank_billet = BankBillet.find(bank_billet.id)

      expect(response.code).to eq(204)
      expect(canceled_bank_billet.status).to eq('canceled')
    end
  end
end
