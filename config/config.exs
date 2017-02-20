# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :campaign,
  ecto_repos: [Campaign.Repo]

config :campaign, Campaign.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "bghfm",
  database: "campaign_dev",
  hostname: "localhost",
  pool_size: 10
