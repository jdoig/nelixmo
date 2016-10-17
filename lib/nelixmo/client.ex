
defmodule Nelixmo.Recipient do
  @moduledoc false
  defstruct [:number]
end

defmodule Nelixmo.Sender do
  @moduledoc false
  defstruct [:id]
end

defmodule Nelixmo.Auth do
  @moduledoc """
  Deals with account details and authorization
  """

  @key Application.get_env(:nelixmo, :key) || System.get_env("NEXMO_API_KEY")
  @secret Application.get_env(:nelixmo, :secret) || System.get_env("NEXMO_API_SECRET")

  @doc "Nexmo api_key"
  def key, do: @key

  @doc "Nexmo api_secret"
  def secret, do: @secret
  
end
