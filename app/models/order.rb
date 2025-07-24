class Order < ApplicationRecord
  belongs_to :user
  belongs_to :domain, optional: true

  PACKAGE_TYPES = ['Bespoke', 'E-commerce'].freeze
  IMPLEMENTATION_TYPES = ['Do It Myself', 'I Need Help'].freeze
  STATUSES = ['pending', 'completed', 'failed'].freeze

  validates :package_type, inclusion: { in: PACKAGE_TYPES }, allow_blank: true
  validates :implementation_type, inclusion: { in: IMPLEMENTATION_TYPES }, allow_blank: true
  validates :step, presence: true, inclusion: { in: 1..4 }
  validates :status, inclusion: { in: STATUSES }
  validates :user_id, uniqueness: true

  validate :domain_required_after_step_one

  scope :pending, -> { where(status: 'pending') }
  scope :completed, -> { where(status: 'completed') }

  def package_price
    case package_type
    when 'Bespoke'
      20000  # £200 in cents
    when 'E-commerce'
      50000  # £500 in cents
    else
      0
    end
  end

  def calculate_amount
    base_price = package_price
    if implementation_type == 'I Need Help'
      (base_price * 0.2).to_i  # 20% deposit
    else
      base_price  # Full price
    end
  end

  def amount_in_pounds
    return 0 if amount_cents.nil?
    amount_cents / 100.0
  end

  # Add these missing methods:
  def next_step
    [step + 1, 4].min
  end

  def previous_step
    [step - 1, 1].max
  end

  def step_valid?
    case step
    when 1
      true  # Domain not required yet for step 1
    when 2
      domain.present? && package_type.present?
    when 3
      domain.present? && package_type.present? && implementation_type.present?
    when 4
      domain.present? && package_type.present? && implementation_type.present?
    else
      false
    end
  end

  def payment_step?
    step == 4
  end

  def deposit_amount?
    implementation_type == 'I Need Help'
  end

  private

  def domain_required_after_step_one
    if step > 1 && domain.blank?
      errors.add(:domain, "must be selected")
    end
  end
end