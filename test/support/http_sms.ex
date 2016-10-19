defmodule Nelixmo.HTTP.SMS.InMemmory do
  @moduledoc false
  import Nelixmo.HTTP.Message.Request

  def send_text(text) do
    text
    |> build_payload
    |> Poison.decode!
    |> Map.new(fn {k,v}-> {k |> String.replace("-", "_") |> String.to_atom, v} end)
  end
end
