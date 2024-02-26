class BankBillet < ActiveResource::Base
  self.site = "https://api-sandbox.kobana.com.br/v1"
  self.element_name = "bank_billets"
  headers['Content-Type'] = 'application/json'
  headers['Accept'] = 'application/json'
  self.auth_type = :bearer
  self.bearer_token = ENV.fetch('BOLETOSIMPLES_API_TOKEN', nil)

  def self.collection_path(prefix_options = {}, query_options = nil)
    super(prefix_options, query_options).gsub('.json', '')
  end

  def self.cancel(id)
    url = "#{site}/#{element_name}/#{id}/cancel"
    HTTParty.put(url,
                 headers: {
                   'Accept' => 'application/json',
                   'Content-Type' => 'application/json',
                   'Authorization' => "Bearer #{bearer_token}"
                 })
  end

  def self.alter(id, params)
    url = "#{site}/#{element_name}/#{id}/"

    BankBillet.fix_params(params) if params['expire_at(1i)'].present?

    HTTParty.put(url,
                 headers: {
                   'Accept' => 'application/json',
                   'Content-Type' => 'application/json',
                   'Authorization' => "Bearer #{bearer_token}"
                 },
                 body: params.to_json)
  end

  def self.fix_params(params)
    if params['expire_at(1i)'].present?
      expire_at = "#{params['expire_at(1i)']}-#{params['expire_at(2i)']}-#{params['expire_at(3i)']}"
      params['expire_at'] = expire_at
      params.delete('expire_at(1i)')
      params.delete('expire_at(2i)')
      params.delete('expire_at(3i)')
    end

    params
  end

  def self.seed # rubocop:disable Metrics/MethodLength
    20.times do
      BankBillet.create(
        customer_address: Faker::Address.street_address,
        customer_neighborhood: Faker::Address.community,
        customer_zipcode: '01310100',
        customer_city_name: 'São Paulo',
        customer_state: 'SP',
        customer_cnpj_cpf: '16.974.923/0001-84',
        customer_person_name: Faker::Name.name,
        expire_at: Faker::Date.between(from: Date.today, to: 1.year.from_now).strftime,
        amount: Faker::Number.decimal(l_digits: 2).to_s
      )
      puts "Bank Billet created!"
    end
  end
end
