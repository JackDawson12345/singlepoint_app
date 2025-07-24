class Manage::AccountSetupController < ApplicationController
  before_action :authenticate_user!
  before_action :check_existing_order, except: [:confirmation]  # Add except: [:confirmation]
  before_action :find_or_create_order, except: [:confirmation]  # Add except: [:confirmation]
  before_action :set_step, except: [:confirmation]             # Add except: [:confirmation]

  def show
    case @step
    when 1
      # Check if user already has a domain
      if current_user.domain.present?
        @order.update(domain: current_user.domain)
        redirect_to account_setup_path(step: 2)
        return
      end
    when 2
      @package_types = Order::PACKAGE_TYPES
    when 3
      @implementation_types = Order::IMPLEMENTATION_TYPES
    when 4
      setup_payment
    end
  end

  def update

    # Handle domain creation in step 1
    if @step == 1 && params[:domain_name].present?
      domain = current_user.build_domain(name: params[:domain_name])
      if domain.save
        @order.update(domain: domain)
        redirect_to account_setup_path(step: 2)
        return
      else
        flash[:error] = domain.errors.full_messages.join(', ')
        render :show
        return
      end
    end

    @order.assign_attributes(order_params)

    if @order.step_valid? && @order.save
      if @order.step == 4
        redirect_to account_setup_path(step: 4)
      else
        redirect_to account_setup_path(step: @order.next_step)
      end
    else
      flash[:error] = @order.errors.full_messages.join(', ')
      show
      render :show
    end
  end

  def process_payment
    @order.amount_cents = @order.calculate_amount

    if @order.save
      begin
        intent = Stripe::PaymentIntent.create({
                                                amount: @order.amount_cents,
                                                currency: 'gbp',
                                                metadata: {
                                                  order_id: @order.id,
                                                  user_id: current_user.id,
                                                  user_email: current_user.email
                                                }
                                              })

        @order.update(stripe_payment_intent_id: intent.id)

        render json: {
          client_secret: intent.client_secret,
          amount: @order.amount_in_pounds
        }
      rescue Stripe::StripeError => e
        render json: { error: e.message }, status: 422
      end
    else
      render json: { error: @order.errors.full_messages }, status: 422
    end
  end

  def payment_success
    @order = current_user.order
    @order.update(status: 'completed')

    redirect_to confirmation_account_setup_path, notice: 'Payment successful!'
  end

  def confirmation
    @order = current_user.order

    # Redirect if order isn't completed
    unless @order&.status == 'completed'
      redirect_to account_setup_path, alert: 'Please complete your order first.'
      return
    end
  end

  def payment_failed
    @order = current_user.order
    @order.update(status: 'failed')

    redirect_to account_setup_path(step: 4),
                alert: 'Payment failed. Please try again.'
  end



  private

  def check_existing_order
    if current_user.order_completed?
      redirect_to manage_root_path, notice: 'You have already completed your order.'
    end
  end

  def find_or_create_order
    @order = current_user.order || current_user.create_order!(step: 1)
  end

  def set_step
    @step = params[:step]&.to_i || @order.step
    @step = [@step, 4].min
    @step = [1, @step].max

    @order.update(step: @step) if @step != @order.step
  end

  def order_params
    params.require(:order).permit(:package_type, :implementation_type)
  end

  def setup_payment
    @order.amount_cents = @order.calculate_amount
    @order.save
  end
end