# frozen_string_literal: true

class SolidusAdmin::Orders::Cart::Component < SolidusAdmin::BaseComponent
  def initialize(order:)
    @order = order
  end
end
