  defmodule ExZentrum do
  @moduledoc """
  Documentation for `ExZentrum`.
  """

  @endpoint_host
  @endpoint Application.get_env(:ex_zentrum, :end_point)


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

  @hotel_content_uri "https://nexus.prod.zentrumhub.com/api/content/hotelcontent/getHotelContent"

  @con_options [recv_timeout: 25000]


  def get_ip_address() do
    {:ok,[{{octet_0, octet_1, octet_2, octet_3}, _broadaddr, _netmask}|_]} = :inet.getif()
    "#{octet_0}.#{octet_1}.#{octet_2}.#{octet_3}"
  end

@hotel_content_default_request %{
    "channelId" =>  Application.fetch_env!(:ex_zentrum, :channel_id),
    "culture" => "en-US",
    "circularRegion" => nil,
    "filterBy" => nil,
    "circularRegion" => %{
      "radiusInKM" =>  5
    },
    "contentFields" => [
      "All"
    ]
}

  def get_hotels_for_destination(location, options  \\ %{})
                        when is_binary(location) and is_map(options) do
    with  {:ok, {lat, lon,  %Geocoder.Location{country_code: country_code}}} <-  coords_from_address(location),
            {:ok, %{body: body, status_code: 200, headers: headers}} <- http_client().post(@hotel_content_uri, build_location_request(lat, lon, options), hotel_content_headers(), @con_options),
                 {:ok, %{ "hotels" => hotels}} <- decode_body(headers, body) do
                    # IO.inspect(reponse, [limit: :infinity])
                    {:ok, hotels |> filter_by_country(country_code)}
          else
                    some_error ->  {:error, some_error}
          end
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


  def build_location_request(centerLat, centerLong, options \\ %{}) do
    circularRegion = %{
      "centerLat" => centerLat,
      "centerLong" => centerLong,
    }

    settings = Enum.into(options, @hotel_content_default_request)
    put_in(settings["circularRegion"], Map.merge(circularRegion, settings["circularRegion"]))
    |> Jason.encode!
  end



  @doc """
 Build the headers for a hotel content request

  ## Examples

      # iex> ExZentrum.hotel_content_headers()
      # [apiKey: _, "customer-ip": "192.168.1.194", accountId: "xa_cnioupcivt", "Accept-Encoding": "gzip, deflate", "Content-Type": "application/json"]

  """
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


defp http_client do
  Application.get_env(:ex_zentrum, :http_client)
end


end
