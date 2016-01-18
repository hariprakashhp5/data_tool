json.array!(@prlinks) do |prlink|
  json.extract! prlink, :id, :region_id, :operator_id, :link1, :link2, :link3, :link4
  json.url prlink_url(prlink, format: :json)
end
