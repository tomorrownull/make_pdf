Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]
  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
  get 'pdf/make'=> 'pdf#make'
end
