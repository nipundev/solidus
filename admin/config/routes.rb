# frozen_string_literal: true

SolidusAdmin::Engine.routes.draw do
  resource :account, only: :show
  resources :products, only: [:index, :show, :edit, :update] do
    collection do
      delete :destroy
      put :discontinue
      put :activate
    end
  end
  resources :orders, only: :index
end
