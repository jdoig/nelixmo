defmodule NelixmoHTTPMessageResposeTest do
  use ExUnit.Case
  doctest Nelixmo.HTTP.Message.Response

  test "can parse result" do
    import Nelixmo.HTTP.Message.Response
    response = """
    {
      "message-count":"3",
      "messages":[
      {
      "status":"0",
      "message-id":"00000124",
      "to":"44123456789",
      "remaining-balance":"1.10",
      "message-price":"0.05",
      "network":"23410"
      },
      {
      "status":"0",
      "message-id":"00000125",
      "to":"44123456789",
      "remaining-balance":"1.05",
      "message-price":"0.05",
      "network":"23410"
      },
      {
      "status":"0",
      "message-id":"00000126",
      "to":"44123456789",
      "remaining-balance":"1.00",
      "message-price":"0.05",
      "network":"23410"
      }]}
     """
     |> decode_response_body

    assert response.message_count == 3
    assert length(response.messages) == 3

    first_msg = List.first(response.messages)
    assert first_msg.status == 0
    assert first_msg.id == "00000124"
    assert first_msg.to == "44123456789"
    assert first_msg.remaining_balance == 1.10
    assert first_msg.price == 0.05
    assert first_msg.network == "23410"
  
  end
end

defmodule NelixmoHTTPMessageRequestTest do
  use ExUnit.Case
  doctest Nelixmo.HTTP.Message.Request

  test "can build request" do
    import Nelixmo.SMS
    result = Nelixmo.SMS.text
      |> from("Test123")
      |> to("440101020304")
      |> message("Hello World")
      |> send_text

    assert result.from == "Test123"
    assert result.to == "440101020304"
    assert result.text == "Hello World"
    assert result.type == "text"
    assert result.api_key == Nelixmo.Auth.key
    assert result.api_secret == Nelixmo.Auth.secret
  end

    test "can build request with options" do
    import Nelixmo.SMS
    result = Nelixmo.SMS.text
      |> from("Test123")
      |> to("440101020304")
      |> message("Hello World")
      |> options(client_ref: "MyRef123", status_report_req: 1, callback: "https://example.com/callback")
      |> send_text

    assert result.from == "Test123"
    assert result.to == "440101020304"
    assert result.text == "Hello World"
    assert result.type == "text"
    assert result.api_key == Nelixmo.Auth.key
    assert result.api_secret == Nelixmo.Auth.secret
    assert result.client_ref == "MyRef123"
    assert result.status_report_req == 1
    assert result.callback == "https://example.com/callback"
  end

end
