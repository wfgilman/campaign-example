defmodule Campaign.Impression do

  use Ecto.Schema

  import Ecto.Query

  alias Campaign.Repo

  schema "impression" do
    field :uuid, :string
    field :campaign_id, :string
    field :device_id, :string
    timestamps()
  end

  @doc """
  Returns N records of the `Impression` table.
  """
  def get_all(limit) do
    query =
      from i in Campaign.Impression,
        limit: ^limit,
        select: {i.uuid, i.campaign_id, i.device_id}
    Repo.all(query)
  end
end
