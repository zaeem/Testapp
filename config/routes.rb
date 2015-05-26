DealSite::Application.routes.draw do
  resources :advertisers do
    resource :publisher
  end

  resources :deals do
    collection do
      get :get_record
    end
    resource :advertiser
  end

  resources :publishers do
    resources :advertisers
  end

  match '/' => 'publishers#index', :as => :root
end
