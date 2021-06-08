defmodule Geo do
  use Application

  def start(_type, _args), do: SupervisorModule.start_link([])
end
