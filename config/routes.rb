Rails.application.routes.draw do

root 'products#index'

category_constraints = {
  category: /(air)|(tropical)|(succulents)|(cacti)|(herbs)|(trees)|(planters)/
}
  get 'merchants', to: 'merchants#index', as: 'merchants'
  get 'merchants/new', to: 'merchants#new', as: 'new_merchant'
  post 'merchants', to: 'merchants#create'
  get 'merchants/:id', to: 'merchants#show', as: 'merchant'

  resources :merchants, except: [:destroy, :edit, :update] do
    get 'orders', to: 'orders#index' #, as: 'merchant_orders' #merchants/:merchant_id/
    patch 'orders/:id/ship', to: 'orders#ship', as: 'ship_order'

    # resources :orders, only: [:index, :ship]
  end

  get 'products(/:category)', to: 'products#index', as: 'products', constraints: category_constraints
  # get 'products/:id', to: 'products#show', as: 'product'
  # get 'products/new', to: 'products#new', as: 'new_product'

  # post 'products', to: 'products#create'
  #
  #  get 'products/:id/edit', to: 'products#edit', as: 'edit_product'
  #
  # post 'products/:id/edit', to: 'products#edit'
  # patch 'products/:id', to: 'products#update'
  resources :products, except: [:index] do
    resources :reviews, only: [:new, :create, :show]
  end #should be nested within products routes
  # post 'reviews', to: 'reviews#create', as: 'root'

  # get 'orders', to: 'orders#index', as: 'orders'  #do we want to include this?
  # can DRY this with resources later
  get 'orders/:id', to: 'orders#show', as: 'order'
  get 'orders/:id/edit', to: 'orders#edit', as: 'edit_order'
  post 'orders/:id/edit', to: 'orders#edit'
  patch 'orders/:id', to: 'orders#update'
  patch 'orders/:id/cancelled', to: 'orders#cancel_order', as: 'cancel'
  # patch 'orders/:id/shipped', to: 'orders#ship', as: 'ship_order'

  # orderedproduct routes
  get 'orderedproducts', to: 'orderedproducts#index', as: 'orderedproducts'

  post 'orderedproducts/:product_id', to: 'orderedproducts#create', as: 'add_orderedproduct'

  get 'orderedproducts/:id/edit', to: "orderedproducts#edit", as: 'edit_op'

  patch 'orderedproducts/:id', to: 'orderedproducts#update', as: 'orderedproduct'
  delete 'orderedproducts/:id', to: 'orderedproducts#destroy'
  # patch 'orderedproducts/:id/shipped', to: 'orderedproducts#ship', as: 'ship_orderedproducts'

  get "/auth/:provider/callback", to: "merchants#auth_callback", as: 'auth_callback'
  delete 'logout', to: 'merchants#destroy'
end
