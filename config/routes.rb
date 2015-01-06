Rails.application.routes.draw do

  resources :nested_invoices

  resources :invoices
  resources :line_items do
    put :save_all, on: :collection
  end

  resources :boxes, only: [:create, :update, :index]
  resources :box_line_items, only: [:destroy] do
    put :save_all, on: :collection
  end

  root to: "invoices#index"

end
