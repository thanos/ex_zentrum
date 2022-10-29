ExUnit.start()
DotenvParser.load_file(".env")


Application.put_env(:ex_zentrum, :api_key, System.get_env("ZENTRUM_API_KEY"))
Application.put_env(:ex_zentrum, :account_id, System.get_env("ZENTRUM_ACCOUNT_ID"))
Application.put_env(:ex_zentrum, :channel_id, "xa-live-channel")
Application.put_env(:ex_zentrum, :end_point, "https://nexus.prod.zentrumhub.com")
Application.put_env(:geocoder, :worker, [provider: Geocoder.Providers.Fake])
Application.put_env(:geocoder, Geocoder.Worker,[ data: %{
    ~r/.*New York, NY.*/ => %{
      lat: 40.7587905,
      lon: -73.9787755,
      bounds: %{
        bottom: 40.7587405,
        left: -73.9788255,
        right: -73.9787255,
        top: 40.7588405,
      },
      location: %{
        city: "New York",
        country: "United States",
        country_code: "us",
        county: "New York County",
        formatted_address: "30 Rockefeller Plaza, New York, NY 10112, United States of America",
        postal_code: "10112",
        state: "New York",
        street: "Rockefeller Plaza",
        street_number: "30"
      },
    },
    {40.7587905, -73.9787755} => %{
      lat: 40.7587905,
      lon: -73.9787755,
      bounds: %{
        bottom: 40.7587405,
        left: -73.9788255,
        right: -73.9787255,
        top: 40.7588405,
      },
      location: %{
        city: "New York",
        country: "United States",
        country_code: "us",
        county: "New York County",
        formatted_address: "30 Rockefeller Plaza, New York, NY 10112, United States of America",
        postal_code: "10112",
        state: "New York",
        street: "Rockefeller Plaza",
        street_number: "30"
      },
    }
  }])

  ok_reponse = %HTTPoison.Response{
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
