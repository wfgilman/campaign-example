# Campaign

Sample application loading records from a MySQL database to in-memory ETS table.

## Installation

Clone the git repository to your local drive and navigate to the folder:
```
$cd campaign
```
Fetch and compile the dependencies:
```
$mix do deps.get, deps.compile
```

## Configuration

The MySQL database configuration is set in `config\config.exs`.

Set the username and password of the database to be created.
```
config :campaign, Campaign.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "",
  database: "campaign_dev",
  hostname: "localhost",
  pool_size: 10
```
Then create the database, run the migrations and seed the database using:
```
$mix ecto.setup
```
This command is an alias which runs the following native mix command in sequence:
```
$mix ecto.create
$mix ecto.migrate
$mix run priv/repo/seeds.exs
```

## Cache Operation

This application is a caching server which loads records from the database into
an in-memory ETS (Erlang Term Storage) table when the application starts up.

Start the application:
```
$iex -S mix
```

Starting the application starts a supervised server which creates and loads
an ETS table from the database on start-up using `init/1`. The records inserted
into the ETS table are returned using the Ecto query: `Campaign.Impression.get_all/1`.

The server maintains the ETS table in state and can perform read operations on
table to query campaigns and devices.

`Campaign.Cache.get_campaigns_matching_device_id/1` returns a list of all campaigns
matching a device ID.
```
iex(2)> Campaign.Cache.get_campaigns_matching_device_id("device15")
[{"bCjfHF32VfJYKFeHDOXyfSyB2ts=", "campaign3", "device15"},
 {"Fvl1aTVAo+D1XBhIfR5WxjWPE2U=", "campaign2", "device15"},
 {"lGEn1yJVRukpcGeA/csDL2vDnZQ=", "campaign2", "device15"},
 {"kwWJBaNWGCMgIQZS+Z0RYdSac90=", "campaign2", "device15"},
 {"HbXzNBhoAiMTNSUWbQp/y1mW8Cc=", "campaign1", "device15"},
 {"xW0d1W01WMWN/09xaA1P497n7ls=", "campaign2", "device15"}]
```

`Campaign.Cache.get_matching_campaigns_linked_by_device_id/1` returns a list of
campaigns which had an impression by the same device, grouped by device ID.
```
iex(7)> Campaign.Cache.get_matching_campaigns_linked_by_device_id("campaign2")
[{"device474", ["campaign2", "campaign5", "campaign1"]},
 {"device238", ["campaign2", "campaign3", "campaign1", "campaign5"]},
 {"device686", ["campaign2", "campaign1", "campaign4"]},
 {"device213", ["campaign2", "campaign5", "campaign3", "campaign4"]},
 {"device400",
  ["campaign2", "campaign5", "campaign4", "campaign1", "campaign3"]},
 {"device786",
  ["campaign2", "campaign4", "campaign5", "campaign3", "campaign1"]},
 {"device110", ["campaign2", "campaign3"]}, {"device515", ["campaign2"]},
 {"device87", ["campaign2", "campaign4"]},
```

The sample data is nonsensical, but illustrates the concept of caching and accessing
data otherwise using resource-heavy queries with Elixir.

## Enhancements

In this example, the ETS looks up are sequential. They could easily be made
concurrent by spawning `Task`s to read the table and report the results back
to the server.
