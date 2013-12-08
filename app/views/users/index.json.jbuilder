json.array!(@users) do |user|
  json.extract! user, :id, :name, :mu
  json.url user_url(user, format: :json)
end
