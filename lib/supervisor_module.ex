defmodule SupervisorModule do
  use Supervisor

  def init(:ok) do
    children = [
      {Offers.OffersAgent, "part-of-offers.csv"},
      {Professions.ProfessionsAgent, "all-professions.csv"},
      GenServerData
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_link(opts), do: Supervisor.start_link(__MODULE__, :ok, opts)
end
