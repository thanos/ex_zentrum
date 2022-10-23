defmodule ExZentrumTest do
  use ExUnit.Case
  doctest ExZentrum

  @test_location %Geocoder.Location{
    city: "Old Toronto",
    country: "Canada",
    country_code: "ca",
    county: nil,
    state: "Ontario",
  }

  test "geocode from address" do
    assert {:ok,  {43.6534817, -79.3839347} } = ExZentrum.coords_from_address("Toronto, ON")
  end
  test "geocode from address failing" do
    assert {:error, nil} = ExZentrum.coords_from_address("tiperari,Planet Mars")
  end

  test "geocode from coordinates" do
    assert {:ok, location} = ExZentrum.location_from_coords({43.653226, -79.383184})
    assert location.country == @test_location.country
  end
  # test "geocode from coordinates fails" do
  #   assert_raise FunctionClauseError, fn ->
  #     ExZentrum.location_from_coords({243.653226, -279.383184})
  #   end
  # end

end
