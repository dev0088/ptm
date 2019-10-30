
class CheckoutController < BaseController
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper

  skip_before_action :authenticate_user!
  before_action :find_interview, only: [:checkout, :purchase, :purchase_addon_seats]
  before_action :handle_token, only: [:purchase, :purchase_addon_seats]
  before_action :set_card_from_params, only: [:purchase, :purchase_addon_seats]
  before_action :set_vars, only: [:purchase]

  def checkout
    bundle_id = (params[:bundle_id] || Bundle.single.id)
    @bundle = Bundle.find(bundle_id)
    @bundles = Bundle.active.count_descending
    @order_total = @bundle.price_in_cents
    @order_total_in_dollars = @order_total / 100.0
    @purchase_url = @interview.nil? ? purchase_path : purchase_path(id: @interview.id)
  end

  # def checkout_posting
  #   @order_total = POSTING_PRICE
  #   @order_total_in_dollars = @order_total / 100.0
  #   @purchase_url = purchase_posting_path(id: @interview.id)
  # end

  def purchase

    @interview = current_user.interviews.where(id: params[:id]).first

    if !@interview.nil? && @interview.free
      @interview.payment_complete!
      return redirect_to interviews_path, notice: "Your interview has been created."
    end

    if @credit_card.nil?
      return redirect_to construct_checkout_path, alert: "Your transaction could not be processed at this time. Invalid card or card on file not found."
    end

    @stripe_charger = StripeCharger.new(current_user, @credit_card, @bundle, @interview)

    # Note: it'd be nice eventually here to perform a basic sanity check to make sure the price displayed
    #  to the user is the same as the one being charged.
    @stripe_charger.charge!
    if @stripe_charger.success?
      @interview.payment_complete! if !@interview.nil?
      current_user.add_bundle!(@bundle)
      amount_str = number_to_currency(@stripe_charger.order_total_in_dollars)
      redirect_to selector_interviews_path(posting: session[:new_interview_posting]), notice: "Your card has been authorized and charged #{amount_str}."
    else
      redirect_to construct_checkout_path, alert: @stripe_charger.declined_explanation
    end
  end

  def purchase_addon_seats
    @addon_seats = ActiveModel::Type::Integer.new.cast(params[:addon_seats_count]) || 0
    options = {addon_seats: @addon_seats}
    @stripe_addon_charger = StripeAddonCharger.new(current_user, @interview, @credit_card, options)
    @stripe_addon_charger.charge!
    if @stripe_addon_charger.success?
      @interview.purchased_addon_seats!(@addon_seats)
      amount_str = number_to_currency(@stripe_addon_charger.order_total_in_dollars)
      redirect_to new_invite_path(interview_id: @interview.id), notice: "Your linked card has been charged #{amount_str} for #{@stripe_addon_charger.order_description}"
    else
      redirect_to interview_path(@interview), alert: @stripe_addon_charger.declined_explanation
    end
  end

  # def purchase_posting
  #   @stripe_posting_charger = StripePostingCharger.new(current_user, @credit_card, @interview)
  #   @stripe_posting_charger.charge!
  #   if @stripe_posting_charger.success?
  #     @interview.purchased_posting!
  #     amount_str = number_to_currency(@stripe_posting_charger.order_total_in_dollars)
  #     redirect_to interview_guests_path(@interview), notice: "Your linked card has been charged #{amount_str} for #{@stripe_posting_charger.order_description}"
  #   else
  #     redirect_to checkout_posting_path(id: @interview.id), alert: @stripe_posting_charger.declined_explanation
  #   end
  # end

  def total
    bundle = Bundle.find(params[:bundle_id])
    bundle_price_formatted = number_to_currency(bundle.price_in_dollars)
    order_total = bundle.price_in_cents
    total_in_dollars = bundle.price_in_dollars
    total_formatted = number_to_currency(total_in_dollars)
    render json: {bundle_id: bundle.id, name: bundle.name, bundle_price_formatted: bundle_price_formatted,
                  total: order_total, total_formatted: total_formatted }
  end

  private

    def find_interview
      @interview = Interview.where(id: params[:id]).first
      # TODO: Authorize interview ownership
    end

    def handle_token
      @stripe_token = params[:stripeToken]
      if !@stripe_token.blank?
        @credit_card = current_user.credit_cards.new(token: @stripe_token)
        if @credit_card.save
          # do nothing
        else
          redirect_to construct_checkout_path, alert: @credit_card.errors.full_messages.join('; ')
        end
      end
    end

    def set_card_from_params
      @credit_card ||= current_user.credit_cards.find_by(id: params[:credit_card][:id])
    end

    def set_vars
      @bundle = Bundle.find(params[:bundle_id])
    end

    def construct_checkout_path
      checkout_path(id: @interview&.id, bundle_id: @bundle&.id)
    end

end