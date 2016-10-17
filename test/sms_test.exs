defmodule NelixmoSMSTest do
  use ExUnit.Case
  import Mock
  doctest Nelixmo.SMS

  test_with_mock "send_text pipe", Nelixmo.HTTP.SMS,
    [send_text: fn(r) -> r end] do

    import Nelixmo.SMS

    result = Nelixmo.SMS.text
      |> from("Test123")
      |> to("440101020304")
      |> message("Hello World")
      |> send_text

    assert result.sender.id == "Test123"
    assert result.recipient.number == "440101020304"
    assert result.message == "Hello World"
  end

  test_with_mock "send_text function", Nelixmo.HTTP.SMS,
    [send_text: fn(r) -> r end] do
    result = Nelixmo.SMS.send_text(from: "Test123", to: "440101020304", message: "Hello World")

    assert result.sender.id == "Test123"
    assert result.recipient.number == "440101020304"
    assert result.message == "Hello World"

  end

end
