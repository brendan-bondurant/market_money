class AtmSerializer
  include JSONAPI::Serializer
  attributes :name, :address, :lat, :lon, :city
end