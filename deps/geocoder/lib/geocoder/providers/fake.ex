defmodule Geocoder.Providers.Fake do
  use Towel

  @error {:error, nil}

  def geocode(opts) do
    coords =
      geocode_from_config(opts[:address])
      |> parse_geocode()

    {:ok, coords}
  end

  def geocode_list(opts) do
    coords =
      geocode_from_config(opts[:address])
      |> parse_geocode()

    {:ok, List.wrap(coords)}
  end

  def reverse_geocode(opts) do
    coords =
      reverse_geocode_from_config(opts[:latlng])
      |> parse_geocode()

    {:ok, coords}
  end

  def reverse_geocode_list(opts) do
    coords =
      reverse_geocode_from_config(opts[:latlng])
      |> parse_geocode()

    {:ok, List.wrap(coords)}
  end

  defp parse_geocode(nil), do: @error

  defp parse_geocode(loaded_config) do
    coords = geocode_coords(loaded_config)
    bounds = geocode_bounds(loaded_config[:bounds])
    location = geocode_location(loaded_config[:location])
    %{coords | bounds: bounds, location: location}
  end

  defp geocode_coords(%{lat: lat, lon: lon}) do
    %Geocoder.Coords{lat: lat, lon: lon}
  end

  defp geocode_coords(_), do: %Geocoder.Coords{}

  defp geocode_bounds(%{top: north, right: east, bottom: south, left: west}) do
    %Geocoder.Bounds{top: north, right: east, bottom: south, left: west}
  end

  defp geocode_bounds(_), do: %Geocoder.Bounds{}

  defp geocode_location(nil), do: %Geocoder.Location{}

  defp geocode_location(location_attrs) do
    Map.merge(%Geocoder.Location{}, location_attrs)
  end

  def get_worker_config() do
    Geocoder.worker_config()
    |> Keyword.get(:data, %{})
  end

  def geocode_from_config(key) do
    {_, value} =
      get_worker_config()
      |> Enum.filter(fn {k, _} -> is_struct(k, Regex) end)
      |> Enum.find(@error, fn {regex, _} -> String.match?(key, regex) end)

    value
  end

  def reverse_geocode_from_config(latlng) do
    {_, value} =
      get_worker_config()
      |> Enum.filter(fn {k, _} -> is_tuple(k) end)
      |> Enum.find(@error, fn {tuple, _} -> tuple == latlng end)

    value
  end
end
