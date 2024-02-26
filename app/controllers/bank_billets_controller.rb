class BankBilletsController < ApplicationController
  def index
    @bank_billets = BankBillet.all(params: { per_page: '50' })
  end

  def show
    @bank_billet = BankBillet.find(params[:id])
  end

  def new
    empty_billet
  end

  def create
    @bank_billet = BankBillet.new(bank_billet_params)
    expire_at = parse_expire_at(params)
    @bank_billet = BankBillet.new(bank_billet_params.merge(expire_at:)) if expire_at
    @bank_billet.save
    redirect_to bank_billet_path(@bank_billet), status: :see_other
  rescue StandardError
    error_message = @bank_billet.errors.full_messages.join(', ') if @bank_billet.errors.any?
    redirect_to new_bank_billet_path(empty_billet), alert: error_message
  end

  def edit
    @bank_billet = BankBillet.find(params[:id])
    @bank_billet.expire_at = Date.parse(@bank_billet.expire_at) if @bank_billet.expire_at.is_a?(String)
  end

  def update
    @bank_billet = BankBillet.find(params[:id])
    response = BankBillet.alter(@bank_billet.id, bank_billet_params) if bank_billet_params

    if response.success?
      redirect_to bank_billet_path(@bank_billet), status: :see_other
    else
      error_message = format_error_message(response['errors'])
      redirect_to edit_bank_billet_path(@bank_billet), alert: error_message
    end
  end

  def cancel
    id = params[:id]
    response = BankBillet.cancel(id)
    return if response.success?

    error_message = errors.map do |error|
      (error['title']).to_s
    end.join(', ')
    redirect_to bank_billet_path(id), alert: error_message
  end

  private

  def format_error_message(errors)
    errors.map do |key, messages|
      "#{key.capitalize} #{messages.join(', ')}"
    end.join(', ')
  end

  def parse_expire_at(params)
    year = params['expire_at(1i)'].to_i
    month = params['expire_at(2i)'].to_i
    day = params['expire_at(3i)'].to_i

    begin
      Date.new(year, month, day).strftime('%Y-%m-%d')
    rescue Date::Error => e
      nil
    end
  end

  def bank_billet_params # rubocop:disable Metrics/MethodLength
    params.require(:bank_billet).permit(:amount,
                                        :expire_at,
                                        :description,
                                        :customer_neighborhood,
                                        :customer_address,
                                        :customer_zipcode,
                                        :customer_city_name,
                                        :customer_state,
                                        :customer_cnpj_cpf,
                                        :customer_person_name,
                                        :notes, :days_for_sue,
                                        :sue_code,
                                        :instructions,
                                        :description,
                                        :reduction_amount)
  end

  def empty_billet
    @bank_billet = BankBillet.new(amount: '',
                                  expire_at: Date.today,
                                  customer_person_name: "",
                                  customer_cnpj_cpf: "",
                                  customer_zipcode: "",
                                  customer_neighborhood: "",
                                  customer_address: "",
                                  customer_city_name: "",
                                  customer_state: "")
  end
end
