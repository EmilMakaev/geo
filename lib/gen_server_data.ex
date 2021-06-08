defmodule GenServerData do
  use GenServer

  ### GenServer API

  def init(state), do: {:ok, state}

  def handle_call(:get_data, _from, state), do: {:reply, state, state}

  def handle_cast({:fill_state, new_state}, _state), do: {:noreply, new_state}

  ### Client API

  def start_link(state \\ []), do: GenServer.start_link(__MODULE__, state, name: __MODULE__)

  def fill_state(latitude_longitude, range) do
    new_state = Common.calculate_by_latitude_longitude_range(latitude_longitude, range)
    GenServer.cast(__MODULE__, {:fill_state, new_state})
  end

  def get_data, do: GenServer.call(__MODULE__, :get_data)
end
