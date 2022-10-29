  defmodule ExZentrum do
  @moduledoc """
  Documentation for `ExZentrum`.
  """





  def coords_from_address(address) when is_binary(address) do
    case result = Geocoder.call(address)  do
      {:ok,  %Geocoder.Coords{lat: lat, lon: lon, location: location}} ->
        {:ok, {lat, lon, location}}
        _ ->
          result
    end

  end

  def location_from_coords({lat, lon} = location) when is_float(lat) and is_float(lon) do
      case result = Geocoder.call(location) do
        {:ok,  %Geocoder.Coords{location: %Geocoder.Location{} = location}} ->
          {:ok, location}
          _ ->
            result
      end
  end


  @con_options [recv_timeout: 25000]






@hotel_content_request %{
    "culture" => "en-US",
    "filterBy" => nil,
    "circularRegion" => %{
      "radiusInKM" =>  5
    },
    "contentFields" => [
      "All"
    ]
}

  def get_hotel_content_for_destination(location, options  \\ %{})
                        when is_binary(location) and is_map(options) do
    hotel_content_uri = "#{Application.get_env(:ex_zentrum, :end_point)}/api/content/hotelcontent/getHotelContent"
    with  {:ok, {lat, lon,  %Geocoder.Location{country_code: country_code}}} <-  coords_from_address(location),
            {:ok, %{body: body, status_code: 200, headers: headers}} <- http_client().post(hotel_content_uri, build_content_request(@hotel_content_request, lat, lon,  options), hotel_content_headers(), @con_options),
                 {:ok, %{ "hotels" => hotels}} <- decode_body(headers, body) do
                    # IO.inspect(reponse, [limit: :infinity])
                    {:ok, hotels |> filter_by_country(country_code)}
          else
                    some_error ->  {:error, some_error}
          end
  end

  def hotel_content_headers do
    [
      apiKey: Application.fetch_env!(:ex_zentrum, :api_key),
      "customer-ip": get_ip_address(),
      accountId: Application.fetch_env!(:ex_zentrum, :account_id),
      "Accept": "Application/json; Charset=utf-8",
      "Accept-Encoding": "gzip, deflate",
      "Content-Type": "application/json"
    ]
  end

  def build_content_request(hotel_content_request, centerLat, centerLong,  options \\ %{}) do
    circularRegion = %{
      "centerLat" => centerLat,
      "centerLong" => centerLong,
    }

    settings = Enum.into(options, hotel_content_request)
    put_in(settings["circularRegion"], Map.merge(circularRegion, settings["circularRegion"]))
    |> Map.put("channelId", Application.fetch_env!(:ex_zentrum, :channel_id))
    |> Jason.encode!
  end



  @hotel_availability_request %{
    "currency" => "USD",
    "checkIn" => "2022-11-20",
    "checkOut" => "2022-11-30",
    "occupancies" => %{
        "numOfAdults" => 2,
        "childAges" => [ 0 ]
      },
    "culture" => "en-US",
    "filterBy" => nil,
    "circularRegion" => %{
      "radiusInKM" =>  5
    },
    "contentFields" => [
      "All"
    ]
}
  def get_hotel_availability_for_destination(location, check_in,  check_out, occupancies, options  \\ %{})
      when is_binary(location) and is_map(options) do

          hotel_available_url  = "#{Application.get_env(:ex_zentrum, :end_point)}/api/hotel/availability"
          options = Map.merge(options, %{
          "checkIn" =>  check_in,
          "checkOut" =>   check_out,
          "occupancies" => occupancies
          })
          with  {:ok, {lat, lon,  %Geocoder.Location{country_code: country_code}}} <-  coords_from_address(location),
               {:ok, %{body: body, status_code: 200, headers: headers}} <- http_client().post(hotel_available_url, build_availability_request(lat, lon, @hotel_availability_request, options), hotel_availability_headers(), @con_options),
                  {:ok, %{ "hotels" => hotels}} <- decode_body(headers, body) do
                  # IO.inspect(response)
                    {:ok, hotels |> filter_by_country(country_code)}
          else
                    some_error ->  {:error, some_error}
          end
  end

  def hotel_availability_headers do
    [
      apiKey: Application.fetch_env!(:ex_zentrum, :api_key),
      "customer-ip": get_ip_address(),
      accountId: Application.fetch_env!(:ex_zentrum, :account_id),
      "Accept": "Application/json; Charset=utf-8",
      "Accept-Encoding": "gzip, deflate",
      "Content-Type": "application/json",
      correlationId: UUID.uuid1()
    ]
  end

  def build_availability_request(centerLat, centerLong, hotel_availability_request, options \\ %{}) do
    circularRegion = %{
      "centerLat" => centerLat,
      "centerLong" => centerLong,
    }

    settings = Enum.into(options, hotel_availability_request)
    put_in(settings["circularRegion"], Map.merge(circularRegion, settings["circularRegion"]))
    |> Map.put("channelId", Application.fetch_env!(:ex_zentrum, :channel_id))
    |> Jason.encode!
  end

  def filter_by_country(hotels, country_code) do
    lc_country_code = String.upcase(country_code)
    hotels
    |> Enum.filter(fn %{"contact" =>
      %{"address"  =>
        %{"country" => %{"code" => code}}}} ->
          lc_country_code == code
        end)
  end









def decode_body(headers, body) do
  g_zipped =
  Enum.any?(headers, fn kv ->
    case kv do
      {"Content-Encoding", "gzip"} -> true
      {"Content-Encoding", "x-gzip"} -> true
      _ -> false
    end
  end)

  if g_zipped do
    :zlib.gunzip(body) |> Jason.decode
  else
    body |> Jason.decode
  end
end



def get_ip_address() do
  {:ok,[{{octet_0, octet_1, octet_2, octet_3}, _broadaddr, _netmask}|_]} = :inet.getif()
  "#{octet_0}.#{octet_1}.#{octet_2}.#{octet_3}"
end

defp http_client do
  Application.get_env(:ex_zentrum, :http_client, HTTPoison)
end


end
