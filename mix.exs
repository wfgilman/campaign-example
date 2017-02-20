defmodule Campaign.Mixfile do
  use Mix.Project

  def project do
    [app: :campaign,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {Campaign, []}]
  end

  defp deps do
    [
      {:ecto, "~> 2.0"},
      {:mariaex, "~> 0.7.3"}
    ]
  end

  defp aliases do
    [
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"]
    ]
  end
end
