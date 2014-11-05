json.array!(@media) do |medium|
  json.extract! medium, :id, :id_media, :user, :text, :image_url, :approve_state, :show_state, :social_net_origin, :media_created_at
  json.url medium_url(medium, format: :json)
end
