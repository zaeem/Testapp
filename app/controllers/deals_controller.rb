class DealsController < ApplicationController
  before_filter :assign_deal, only: [ :show, :edit, :update, :destroy ]
  before_filter :set_view_paths, only: :show
  before_filter :load_all_advisers, only: [ :new, :edit, :update, :create ]


  def index
    @deals = Deal.all
  end

  def get_record
    p = params[:page].to_i
    p = p - 1 if p != 0
    limit = 100
    offset = p * limit
    @deals = Deal.get_data(limit,  offset)
    render partial: 'deals'
  end

  def show
    respond_to do |format|
      format.html { render layout: "deals/show" }
      format.json { render json: @deal }
    end
  end

  def new
    @deal = Deal.new
  end

  def create
    @deal = Deal.new(params[:deal])
    if @deal.save
      redirect_to edit_deal_path(@deal), notice: 'Deal was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @deal.update_attributes(params[:deal])
      redirect_to edit_deal_path(@deal), notice: 'Deal was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @deal.destroy
    redirect_to deals_url
  end


  protected
  def load_all_advisers
    @advertisers = Advertiser.all
  end
  
  def assign_deal
    @deal = Deal.find(params[:id])
  end

  def set_view_paths
    prepend_view_path "app/themes/#{@deal.advertiser.publisher.theme}/views"
  end
end
