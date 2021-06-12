defmodule Common do
  @doc """
  Calculates a bounding box around a point with a radius in meters.
  Сreates a Map with min-max latitude and longitude.
  """
  def calculate_by_latitude_longitude_range(range, radius) do
    Geocalc.bounding_box(range, radius)
    |> Stream.with_index()
    |> Stream.map(fn {[head, tail], index} ->
      if index == 0 do
        %{"min_latitude" => head, "min_longitude" => tail}
      else
        %{"max_latitude" => head, "max_longitude" => tail}
      end
    end)
    |> Enum.reduce(&Map.merge(&1, &2))
    |> offer_filter()
  end

  @doc """
  Takes offers from Agent and leaves only those that are included
  in the range of min-max latitude and longitude.
  """
  def offer_filter(filter) do
    offers = Offers.OffersAgent.value()

    Enum.filter(offers, fn offer ->
      latitude = String.to_float(offer["office_latitude"])
      longitude = String.to_float(offer["office_longitude"])

      if filter["min_latitude"] < latitude and latitude < filter["max_latitude"] do
        if filter["min_longitude"] < longitude and longitude < filter["max_longitude"] do
          offer
        end
      end
    end)
  end

  @doc """
  Gets Мap of professions grouped by "category_name".
  """
  def count_offers_by_profession(professions) do
    Stream.map(professions, fn {key, values} ->
      amount_of_offers = Enum.reduce(values, 0, &(&1["amount_of_offers"] + &2))

      %{"category_name" => key, "amount_of_offers" => amount_of_offers}
    end)
    |> show_amount_of_offers_by_professions()
  end

  def show_amount_of_offers_by_professions(professions) do
    Enum.each(professions, fn %{"category_name" => name, "amount_of_offers" => amount} ->
      IO.puts("#{name} - #{amount}")
    end)
  end

  def show_lenth() do
    Professions.Professions.length_by_professions()
    IO.puts("-------")
    Offers.Offers.length_by_continent()
  end

  @doc """
  Calculates the number of offers per profession on the received data
  (longitude, latitude, and radius)
  """
  def count_by_incoming_data() do
    GenServerData.get_data()
    |> Offers.Offers.group_offers_by_id()
    |> Professions.Professions.modify_professions()
  end

  def show_incoming_data_lenth() do
    count_by_incoming_data()
    IO.puts("-------")
    count_by_continent_incoming_data()
  end

  def count_by_continent_incoming_data do
    GenServerData.get_data()
    |> Offers.Offers.modify_offers()
  end

  @doc """
  Returning a list of job offers corresponding to latitude, longitude and range
  """
  def show_list_by_latitude_longitude_range do
    GenServerData.get_data()
  end
end
