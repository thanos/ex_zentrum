defmodule ExZentrumTest do
  use ExUnit.Case
  #doctest ExZentrum



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
    assert {:ok,  {40.7127281, -74.0060152, location} } = ExZentrum.coords_from_address("New York, NY")
  end
  # test "geocode from address failing" do
  #   assert {:error, nil} = ExZentrum.coords_from_address("tiperari,Planet Mars")
  # end

  @ok_reponse %HTTPoison.Response{
    status_code: 200,
    body: <<31, 139, 8, 0, 0, 0, 0, 0, 4, 3, 236, 189, 137, 110, 227, 72, 151,
      166, 125, 43, 132, 49, 192, 244, 224, 79, 166, 184, 47, 133, 158, 30, 56,
      119, 87, 238, 118, 174, 213, 211, 72, 4, 201, 160, 68, 91, 155, 169>>,
    headers: [
      {"Date", "Fri, 28 Oct 2022 16:46:22 GMT"},
      {"Content-Type", "application/json; charset=utf-8"},
      {"Transfer-Encoding", "chunked"},
      {"Connection", "keep-alive"},
      {"Server", "Kestrel"},
      {"Content-Encoding", "gzip"},
      {"Vary", "Accept-Encoding"}
    ],
    request_url: "https://nexus.prod.zentrumhub.com/api/content/hotelcontent/getHotelContent",
    request: %HTTPoison.Request{
      method: :post,
      url: "https://nexus.prod.zentrumhub.com/api/content/hotelcontent/getHotelContent",
      headers: [
        apiKey: "cfed5799-4be0-4ad2-b8c1-4c9e04e985fb",
        "customer-ip": "192.168.1.194",
        accountId: "xa_cnioupcivt",
        "Accept-Encoding": "gzip, deflate",
        "Content-Type": "application/json"
      ],
      body: "{\"channelId\":\"xa-live-channel\",\"circularRegion\":{\"centerLat\":40.7587905,\"centerLong\":-73.9787755,\"radiusInKM\":1},\"contentFields\":[\"All\"],\"culture\":\"en-US\",\"filterBy\":{\"ratings\":{\"max\":5,\"min\":5}}}",
      params: %{},
      options: [recv_timeout: 25000]
    }
  }



  test "geocode from coordinates" do
    assert {:ok, location} = ExZentrum.location_from_coords({40.7587905, -73.9787755})
    assert location.country == @test_location.country
  end


@simple_request   "{\"channelId\":\"xa-live-channel\",\"circularRegion\":{\"centerLat\":40.7587905,\"centerLong\":-73.9787755,\"radiusInKM\":5},\"contentFields\":[\"All\"],\"culture\":\"en-US\",\"filterBy\":null}"
test "build_location_address" do
  assert @simple_request ==  ExZentrum.build_location_request(40.7587905, -73.9787755)
end


test "hotel_content_headers" do
  key = Application.fetch_env!(:ex_zentrum, :api_key)
  assert  assert match?([{:apiKey,  key}|_], ExZentrum.hotel_content_headers())
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


test "get_hotels_for_destination" do
   response = ExZentrum.get_hotels_for_destination("New York, NY", %{
      "circularRegion" => %{ "radiusInKM" =>  1},
      "filterBy" => %{
        "ratings"=> %{
          "max" => 5,
         "min" => 5
        }
      }
    })
    assert {:ok, [%{"distance" => "0"}|_] = hotels} = response
    IO.puts("count #{Enum.count(hotels)}")
  end

  # test "get_hotels_from_ids" do
  #   response = ExZentrum.get_hotels_from_ids(["39629242"])
  #   assert {:ok, [%{"id" => "39629242otel"}|_] = hotels} = response
  # end

end
