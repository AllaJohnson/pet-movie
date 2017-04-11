Rails.application.routes.draw do
  devise_for :users
   #default_url_options :host => "locajhost:3000"
  #devise_for :podcasts

  resources :users, only: [:index, :show] do
     resources :movies
  end

   authenticated :user do
       root 'users#dashboard', as: "authenticated_root"
   end

   root 'welcome#index'
  # get 'podcasts', to: 'podcasts#podcasts'
  # get 'podcasts/show', to: 'podcasts#show'
  # get 'podcasts/dashboard', to: 'podcasts#dashboard'
  # get 'podcasts/episode', to: 'podcasts#episode'
  # get 'welcome/sign_in', to: 'welcome#sign_in'
  # get 'welcome/sign_up', to: 'welcome#sign_up'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
