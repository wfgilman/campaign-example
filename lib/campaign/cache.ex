defmodule Campaign.Cache do
  @moduledoc """
  Server maintaining an ETS table for the database records to query.
  """

  use GenServer

  # Client API

  def start_link(table_name) do
    GenServer.start_link(__MODULE__, table_name, name: __MODULE__)
  end

  @doc """
  Returns all records matching a device ID.
  """
  def get_campaigns_matching_device_id(device_id) do
    GenServer.call(__MODULE__, {:device_id, device_id})
  end

  @doc """
  Returns all campaigns of a device which made an impression for a given
  campaign.
  """
  def get_matching_campaigns_linked_by_device_id(campaign_id) do
    GenServer.call(__MODULE__, {:campaign_id, campaign_id})
  end

  ## Callbacks

  def init(table_name) do
    :ets.new(table_name, [:named_table, read_concurrency: true])
    for record <- Campaign.Impression.get_all(5_000) do
      :ets.insert(table_name, record)
    end
    {:ok, %{ets_table: table_name}}
  end

  def handle_call({:device_id, device_id}, _from, %{ets_table: table_name} = state) do
    results = :ets.match_object(table_name, {:"_", :"_", device_id})
    {:reply, results, state}
  end

  def handle_call({:campaign_id, campaign_id}, _from, %{ets_table: table_name} = state) do
    device_ids = :ets.match(table_name, {:"_", campaign_id, :"$1"}) |> List.flatten()
    results =
      for device_id <- device_ids do
        campaigns =
          :ets.match(table_name, {:"_", :"$1", device_id})
          |> List.flatten()
          |> Enum.uniq()
        {device_id, campaigns}
      end
    {:reply, results, state}
  end

end
