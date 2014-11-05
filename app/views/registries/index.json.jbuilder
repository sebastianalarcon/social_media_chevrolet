json.array!(@registries) do |registry|
  json.extract! registry, :id, :last_registry
  json.url registry_url(registry, format: :json)
end
