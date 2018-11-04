Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/' => 'admin_panel#home'

  get '/admin_panel' => 'admin_panel#home'
  get '/admin_panel/new' => 'admin_panel#new'

  post 'products' => 'admin_panel#create'
end
