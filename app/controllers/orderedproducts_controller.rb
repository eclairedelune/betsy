class OrderedproductsController < ApplicationController

  def index
    find_order
    @ops = Orderedproduct.where(order: @order)
  end

  def create
    find_order
    start_new_order if @order.nil?
    op = Orderedproduct.find_by(product_id: params[:product_id], order_id: @order.id)
    if op
      op.quantity += 1
    else
      op = Orderedproduct.new(product_id: params[:product_id], order_id: @order.id, quantity: 1)
    end
    if op.save #may change this
      flash[:status] = :success
      flash[:result_text] = "Successfully added #{Product.find_by(id: op.product_id).name} to cart"
    else
      flash[:status] = :failure
      flash[:result_text] = "Unable to add #{Product.find_by(id: op.product_id).name} to cart"
      flash[:messages] = @product.errors.messages
    end
    redirect_to orderedproducts_path
  end

  def update
    find_order
    @op = Orderedproduct.find_by(id: params[:id], order_id: @order.id)
    @op.update_attributes(op_params)

    if @op.save
      flash[:status] = :success
      flash[:result_text] = "Successfully updated item quantity"
      redirect_to orderedproducts_path
    else
      flash[:status] = :failure
      flash[:result_text] = "Unable to add item to cart"
      flash[:message] = @op.errors.messages
      redirect_to orderedproducts_path
    end
  end

  def destroy
    find_order
    ops = Orderedproduct.where(id: params[:id], order_id: @order.id)
    if ops.empty?
      head :not_found
    else
      flash[:status] = :success
      flash[:result_text] = "Successfully deleted #{Product.find_by(id: ops.first.product_id).name} from cart"
      ops.destroy_all
      redirect_to orderedproducts_path
    end
  end

  private

  def op_params
    return params.require(:orderedproduct).permit(:quantity)
  end

  def start_new_order
    @order = Order.create(status: "pending")
    session[:order_id] = @order.id
  end

  def find_order
      @order = Order.find_by(id: session[:order_id])
  end

end
