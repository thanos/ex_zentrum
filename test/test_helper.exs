ExUnit.start()
DotenvParser.load_file(".env")


Application.put_env(:ex_zentrum, :api_key, System.get_env("ZENTRUM_API_KEY"))
Application.put_env(:ex_zentrum, :account_id, System.get_env("ZENTRUM_ACCOUNT_ID"))
Application.put_env(:ex_zentrum, :channel_id, "xa-live-channel")
Application.put_env(:ex_zentrum, :end_point, "https://nexus.prod.zentrumhub.com/api")
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
