defmodule ExZentrum do
  @moduledoc """
  Documentation for `ExZentrum`.
  """


  @endpoint Application.get_env(:ex_zentrum, :end_point)


  def coords_from_address(address) when is_binary(address) do
    case result = Geocoder.call(address)  do
      {:ok,  %Geocoder.Coords{lat: lat, lon: lon}} ->
        {:ok, {lat, lon}}
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



  @doc """
  Hello world.

  ## Examples

      iex> ExZentrum.hello()
      :world

  """



end
