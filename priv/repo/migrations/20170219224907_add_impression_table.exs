defmodule Campaign.Repo.Migrations.AddImpressionTable do
  use Ecto.Migration

  def change do
    create table(:impression) do
      add :uuid, :string
      add :campaign_id, :string
      add :device_id, :string
      timestamps()
    end

    create unique_index(:impression, [:uuid])
  end
end
