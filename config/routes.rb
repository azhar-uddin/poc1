Rails.application.routes.draw do
  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
  
  get "log_in" => "sessions#new", :as => "log_in"
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "sign_up" => "users#new", :as => "sign_up"
  root "chats#index"
  get "reset_password" => "users#reset_password", :as => "reset_password"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	resources :users, only:[:new, :create] do
   resources :chats, only: [:index, :show, :create]
   member do
      get :confirm_email
      get :new_password
      post :change_password
   end
  end 
	resources :sessions, only:[:new, :destroy, :create]
  resources :messages, only:[:create]
end
