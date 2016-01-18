json.array!(@packs) do |pack|
  json.extract! pack, :id, :price, :offer, :validity, :description, :tag
  json.url pack_url(pack, format: :json)
end
