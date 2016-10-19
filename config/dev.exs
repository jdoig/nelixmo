use Mix.Config

config :nelixmo,
  key: "test_key",
  secret: "test_secret",
  nelixmo_api: Nelixmo.HTTP.SMS,
  nelixmo_sms_uri: "https://rest.nexmo.com/sms"
