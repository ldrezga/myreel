Rails.application.routes.draw do

  root 'user#index'

  get 'user/profile' => 'user#index', as: 'user_profile'
  get 'user/movies' => 'user#movies', as: 'user_movies'
  get 'user/watchlist' => 'watchlist#watchlist', as: 'user_watchlist'
  get 'auth/:provider/callback' => 'sessions#create'
  get 'auth/failure' => 'home#index'
  get 'signout' => 'sessions#destroy', as: 'signout'
  get 'recommend/genre' => 'recommend#genre', as: 'recommend_genre'
  get 'recommend/filter' => 'recommend#filter', as: 'recommend_filter'
  get 'recommend/genre/:name' => 'recommend#subgenre', as: 'recommend_subgenre'
  get 'recommend/influencer' => 'recommend#influencer', as: 'recommend_influencer'
  get 'recommend/influencer/:uid' => 'recommend#single_influencer', as: 'recommend_single_influencer'
  get 'recommend/from-friend' => 'recommend#friend', as: 'recommend_friend'
  post 'add-to-watchlist' => 'watchlist#add_to_watchlist', as: 'add_to_watchlist'
  delete 'remove-from-watchlist' => 'watchlist#remove_from_watchlist', as: 'remove_from_watchlist'
  post 'add-to-watched' => 'watchlist#add_to_watched', as: 'add_to_watched'
  delete 'remove-from-watched' => 'watchlist#remove_from_watched', as: 'remove_from_watched'

  get 'user/following' => 'friend#friends', as: 'user_friend'
  post 'add-to-friends' => 'friend#add_to_friends', as: 'add_to_friends'
  delete 'remove-from-friends' => 'friend#remove_from_friends', as: 'remove_from_friends'

  get 'recalculate' => 'master#recalculate', as: 'recalculate'

  get 'movies/:slug' => 'movies#single_movie', as: 'single_movie'

  resources :user do
    resources :usermovies
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
