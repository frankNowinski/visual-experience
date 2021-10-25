Rails.application.routes.draw do
  resources :campaigns, only: [:show, :new, :create, :edit, :update] do
    resources :assets, only: [:show, :new, :create, :edit, :update]
  end
end
