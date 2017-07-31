Rails.application.routes.draw do
  get 'score', to: 'words#score'

  get 'game', to: 'words#game'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
