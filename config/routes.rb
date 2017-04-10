Rails.application.routes.draw do
   #default_url_options :host => "locajhost:3000"
  devise_for :podcasts

  resources :podcasts, only: [:index, :show] do
     resources :episodes
  end

   authenticated :podcast do
       root 'podcasts#dashboard', as: "authenticated_root"
   end

   root 'welcome#index'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
