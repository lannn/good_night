Rails.application.routes.draw do
  defaults format: :json do
    resources :sleep_clocks, only: [:index, :show, :create, :update, :destroy]
    resources :followings, only: [:create, :destroy]
  end
end
