defmodule Offers.OffersAgent do
  use Agent

  def start_link(link) do
    initial_value =
      link
      |> Path.expand(__DIR__)
      |> File.stream!()
      |> Stream.map(& &1)
      |> CSV.decode(separator: ?,, headers: true)
      |> Offers.Offers.group_by_latitude_and_longitude()
      |> Offers.Offers.add_continent_to_offers()

    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def value, do: Agent.get(__MODULE__, & &1)
end
