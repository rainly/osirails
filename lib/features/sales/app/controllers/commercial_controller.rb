class CommercialController < ApplicationController
  attr_accessor :current_order_step
  before_filter :check, :except => [:index]
  
  helper 'orders'
  
  def index
    #@orders = []
    #Order.find(:all).each {|order| @orders << order if order.step = ""}
    @orders = Order.find(:all)
  end
  
  def show

  end
  
  def edit

  end
  
  protected
  
  def check
    @order = Order.find(params[:order_id])
    @current_order_step = @order.step.name
  end
end