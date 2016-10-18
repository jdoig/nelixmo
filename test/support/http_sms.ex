defmodule Nelixmo.HTTP.SMS.InMemmory do
  @moduledoc false

  def send_text(text) do
    text |> build_payload |> Poison.decode!
  end
end
