defmodule Offers.Offers do
  @doc """
  Gets the country code based on latitude and longitude, then determines the continent.
  Add "continent" to offers Map.
  """
  def add_continent_to_offers(offers) do
    Enum.map(offers, fn {_key, [head | tail]} ->
      %{"office_latitude" => latitude, "office_longitude" => longitude} = head
      %{details: %{country_code: country_code}} = LibLatLon.lookup({latitude, longitude})

      [%{continent: continent} | _tail] =
        Countries.filter_by(:alpha2, String.upcase(country_code))

      tail = Enum.map(tail, &Map.put(&1, "continent", continent))

      [Map.put(head, "continent", continent) | tail]
    end)
    |> List.flatten()
  end

  def length_by_continent() do
    Professions.Professions.get_offers()
    |> modify_offers()
  end

  @doc """
  Groups by "continent", then it takes only first element of grouped offers, then
  add "offers_by_continent" to offers Map.
  """
  def modify_offers(offers) do
    offers
    |> group_by_continent()
    |> Enum.map(fn {_key, values} ->
      [head | _tail] = values
      Map.put(head, "offers_by_continent", length(values))
    end)
    |> show_amout_of_offers_by_continent()
  end

  defp group_by_continent(offers) do
    Enum.group_by(offers, &Map.get(&1, "continent"))
  end

  defp show_amout_of_offers_by_continent(offers) do
    Enum.each(offers, fn %{"continent" => continent, "offers_by_continent" => amout} ->
      IO.puts("#{continent} - #{amout}")
    end)
  end

  def group_offers_by_id(offers), do: Enum.group_by(offers, &Map.get(&1, "profession_id"))

  def group_by_latitude_and_longitude(offers) do
    Enum.group_by(offers, &Map.get(&1, "office_latitude", "office_longitude"))
  end
end
