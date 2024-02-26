require 'rails_helper'

RSpec.describe BankBilletsController, type: :controller do # rubocop:disable Metrics/BlockLength
  describe "#index" do
    it "returns a success response" do
      VCR.use_cassette('Controller/_index/bank_billets_index') do
        get :index

        expect(response).to be_successful
        expect(assigns(:bank_billets)).to be_an(ActiveResource::Collection)
        expect(assigns(:bank_billets).first).to be_a(BankBillet)
      end
    end
  end

  describe "#show" do
    let(:bank_billet) { BankBillet.create(valid_bank_billet_attributes) }

    it "returns a success response" do
      VCR.use_cassette('Controller/_show/bank_billets_show') do
        get :show, params: { id: bank_billet.id }

        expect(response).to be_successful
        expect(assigns(:bank_billet)).to be_a(BankBillet)
        expect(assigns(:bank_billet)).to eq(bank_billet)
      end
    end
  end

  describe "#new" do
    it "returns a success response" do
      get :new

      expect(response).to be_successful
    end
  end

  describe "#create" do
    it "returns a success response" do
      VCR.use_cassette('Controller/_create/bank_billets_create') do
        post :create, params: {
          bank_billet: valid_bank_billet_attributes
        }

        expect(response).to redirect_to(bank_billet_path(assigns(:bank_billet)))
        expect(assigns(:bank_billet)).to be_a(BankBillet)
      end
    end
  end

  describe "#edit" do
    let(:bank_billet) { BankBillet.create(valid_bank_billet_attributes) }

    it "returns a success response" do
      VCR.use_cassette('Controller/_edit/bank_billets_edit') do
        get :edit, params: { id: bank_billet.id }

        expect(response).to be_successful
        expect(assigns(:bank_billet)).to be_a(BankBillet)
      end
    end
  end

  describe "#update" do
    let(:bank_billet) { BankBillet.create(valid_bank_billet_attributes) }

    it "returns a success response" do
      VCR.use_cassette('Controller/_update/bank_billets_update') do
        put :update, params: {
          id: bank_billet.id,
          bank_billet: valid_bank_billet_attributes
        }

        expect(response).to redirect_to(bank_billet_path(assigns(:bank_billet)))
        expect(assigns(:bank_billet)).to be_a(BankBillet)
        expect(assigns(:bank_billet)).to eq(bank_billet)
      end
    end
  end

  describe "#cancel" do
    let(:bank_billet) { BankBillet.create(valid_bank_billet_attributes) }

    it "returns a success response" do
      VCR.use_cassette('Controller/_cancel/bank_billets_cancel') do
        delete :cancel, params: { id: bank_billet.id }

        expect(response).to be_successful
      end
    end
  end

  private

  def valid_bank_billet_attributes # rubocop:disable Metrics/MethodLength
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
end
