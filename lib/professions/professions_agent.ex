defmodule Professions.ProfessionsAgent do
  use Agent

  def start_link(link) do
    initial_value =
      link
      |> Path.expand(__DIR__)
      |> File.stream!()
      |> Stream.map(& &1)
      |> CSV.decode(separator: ?,, headers: true)
      |> Enum.to_list()

    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def value, do: Agent.get(__MODULE__, & &1)
end
