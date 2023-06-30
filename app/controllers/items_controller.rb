class ItemsController < ApplicationController
  before_action :find_user, except: [:index]

  def index
    if params[:user_id]
      user = User.find_by(id: params[:user_id])
      if user
        items = user.items
        render json: items, except: [:created_at, :updated_at], include: { user: { except: [:created_at, :updated_at] } }
      else
        render_not_found_response
      end
    else
      items = Item.all
      render json: items, except: [:created_at, :updated_at], include: { user: { except: [:created_at, :updated_at] } }
    end
  end

  def show
    item = @user.items.find_by(id: params[:id])
    if item
      render json: item, except: [:created_at, :updated_at], include: { user: { except: [:created_at, :updated_at] } }
    else
      render_not_found_response
    end
  end

  def create
    if @user
      new_item = @user.items.create(item_params)
      render json: new_item, status: :created
    else
      render_not_found_response
    end
  end

  private

  def item_params
    params.permit(:name, :description, :price)
  end

  def find_user
    @user = User.find_by(id: params[:user_id])
  end

  def render_not_found_response
    render json: { error: 'User not found' }, status: :not_found
  end
end