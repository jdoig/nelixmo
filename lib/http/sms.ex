defmodule Nelixmo.HTTP.Message.Response do
  @moduledoc false
  defstruct [:id, :price, :network, :remaining_balance, :to, :status, :error_text, :client_ref]
end

defmodule Nelixmo.HTTP.SMS do
  use HTTPoison.Base

  @moduledoc false

  @expected_fields ~w(message-count messages)

  defp process_url(url), do: "https://rest.nexmo.com/sms" <> url
  defp process_request_headers(_headers), do: [{"Content-Type", "application/json"}]

  defp decode_map(map) when is_map(map), do: struct(Nelixmo.HTTP.Message.Response, Map.new(map, &decode_element/1))
  defp decode_element({"message-count", value}), do: {:message_count, String.to_integer(value)}
  defp decode_element({"message-id", value}), do: {:id, value}
  defp decode_element({"message-price", value}), do: {:price, String.to_float(value)}
  defp decode_element({"network", value}), do: {:network, value}
  defp decode_element({"client-ref", value}), do: {:client_ref, value}
  defp decode_element({"remaining-balance", value}), do: {:remaining_balance, String.to_float(value)}
  defp decode_element({"to", value}), do: {:to, value}
  defp decode_element({"status", value}), do: {:status, String.to_integer(value)}
  defp decode_element({"messages", value}), do: {:messages, Enum.map(value, &decode_map/1)}
  defp decode_element({"error-text", value}), do: {:error_text, value}

  defp process_response_body(body) do
    body
    |> Poison.decode!
    |> Map.take(@expected_fields)
    |> Map.new(&decode_element/1)
  end


  defp build_options(text) do
    options = Map.get(text, :options)
    if is_nil(options) do
      %{}
    else
      %{:callback => options.callback,
	"client-ref" => options.client_ref,
	"status-report-req" => options.status_report_req}
        |> Enum.reject(fn{k,v}-> is_nil(v) end)
        |> Enum.into(%{})
    end
  end

  defp build_payload(text) do
    json = Map.merge(%{
      :from => text.sender.id,
      :to => text.recipient.number,
      :type => text.type,
      :text => text.message,
      :api_key => Nelixmo.Auth.key,
      :api_secret => Nelixmo.Auth.secret
    }, build_options(text))
    |> Poison.encode!
  end

  def send_text(text) do
    json = build_payload text
    post!("/json", json).body
  end

end
