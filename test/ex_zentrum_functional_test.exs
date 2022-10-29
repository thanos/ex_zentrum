defmodule ExZentrumFunctionTest do
  use ExUnit.Case
  #doctest ExZentrum



describe "functional tests connecting to the Zentrum apis" do






test "get_hotels_for_destination" do
   response = ExZentrum.get_hotel_content_for_destination("New York, NY", %{
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


  test "get_hotel_availability_for_destination" do
    response = ExZentrum.get_hotel_availability_for_destination("New York, NY",
    "2022-11-20", "2022-11-30", [
      %{
        "numOfAdults" => 2,
        "childAges" => [
          0
        ]
      }
    ],  %{
       "circularRegion" => %{ "radiusInKM" =>  5},
       "filterBy" => %{
         "ratings"=> %{
           "max" => 5,
          "min" => 0
         }
       }
     })
     assert {:ok, [%{"distance" => "0"}|_] = hotels} = response
     IO.puts("count #{Enum.count(hotels)}")
   end
end
end
