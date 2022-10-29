defmodule ExZentrumUnitTest do
  use ExUnit.Case
  #doctest ExZentrum

describe "api unit tests" do



  @test_location %Geocoder.Location{
    city: "New York",
    country: "United States",
    country_code: "us",
    county: "New York County",
    formatted_address: "30 Rockefeller Plaza, New York, NY 10112, United States of America",
    postal_code: "10112",
    state: "New York",
    street: "Rockefeller Plaza",
    street_number: "30"
  }

  test "geocode from address" do
    assert {:ok,  {40.7127281, -74.0060152, _location} } = ExZentrum.coords_from_address("New York, NY")
  end
  # test "geocode from address failing" do
  #   assert {:error, nil} = ExZentrum.coords_from_address("tiperari,Planet Mars")
  # end





  test "geocode from coordinates" do
    assert {:ok, location} = ExZentrum.location_from_coords({40.7587905, -73.9787755})
    assert location.country == @test_location.country
  end

@simple_request_default %{"circularRegion" => %{"radiusInKM" => 5}, "channelId" => "xa-live-channel"}
@simple_request   "{\"channelId\":\"xa-live-channel\",\"circularRegion\":{\"centerLat\":40.7587905,\"centerLong\":-73.9787755,\"radiusInKM\":5}}"
test "build_content_request" do
  assert @simple_request ==  ExZentrum.build_content_request(@simple_request_default, 40.7587905, -73.9787755)
end


test "hotel_content_headers" do
  key = Application.fetch_env!(:ex_zentrum, :api_key)
  assert  assert match?([{:apiKey,  ^key}|_], ExZentrum.hotel_content_headers())
end


test "decode_body - not zipped" do
  assert {:ok, %{}} == ExZentrum.decode_body([{"Content-Encoding", "json"}], "{}")
end

test "decode_body - gzip" do
  assert {:ok, %{}} == ExZentrum.decode_body([{"Content-Encoding", "gzip"}], :zlib.gzip("{}"))
end

test "decode_body - x-gzip" do
  assert {:ok, %{}} == ExZentrum.decode_body([{"Content-Encoding", "x-gzip"}], :zlib.gzip("{}"))
end


test "filter_by_country" do
  hotels = [%{
    "contact" => %{
      "address" => %{
        "country" => %{"code" => "US", "name" => "United States Of America"},
      }}},
      %{
        "contact" => %{
          "address" => %{
            "country" => %{"code" => "ZA", "name" => "Zambia"},
          },
    }
    }]
  assert 1 == ExZentrum.filter_by_country(hotels, "US") |> Enum.count()
end
end

end
