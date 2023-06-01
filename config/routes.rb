# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :projects do
    resources :comments, only: [:create]
  end

  root to: 'home#index'
end
