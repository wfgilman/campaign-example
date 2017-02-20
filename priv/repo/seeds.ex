campaigns =
  for id <- 1..5 do
    "campaign#{id}"
  end

devices =
  for id <- 1..1_000 do
    "device#{id}"
  end

for _id <- 1..5_000 do
  Campaign.Repo.insert! %Campaign.Impression{
    uuid: :crypto.strong_rand_bytes(20) |> Base.encode64(),
    campaign_id: Enum.random(campaigns),
    device_id: Enum.random(devices)
  }
end
