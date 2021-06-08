defmodule Professions.Professions do
  def get_offers(), do: Offers.OffersAgent.value()

  def length_by_professions() do
    get_offers()
    |> Offers.Offers.group_offers_by_id()
    |> modify_professions()
  end

  @doc """
  Gets Мap of offers grouped by "profession_id" and takes professions from Agent.
  Add "amount_of_offers" to professon Map by comparing "id" offers and professions.
  """
  def modify_professions(offers) do
    Professions.ProfessionsAgent.value()
    |> Stream.map(fn professon ->
      if offers[professon["id"]] do
        amount_of_offers = length(offers[professon["id"]])
        Map.put(professon, "amount_of_offers", amount_of_offers)
      end
    end)
    |> Enum.reject(&is_nil/1)
    |> group_professions_by_department()
    |> Common.count_offers_by_profession()
  end

  defp group_professions_by_department(professions) do
    Enum.group_by(professions, &Map.get(&1, "category_name"))
  end
end
