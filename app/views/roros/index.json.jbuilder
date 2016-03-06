json.array!(@roros) do |roro|
  json.extract! roro, :id, :name
  json.url roro_url(roro, format: :json)
end
