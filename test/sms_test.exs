defmodule NelixmoSMSTest do
  use ExUnit.Case
  doctest Nelixmo.SMS

  test "send_text pipe" do
    import Nelixmo.SMS

    result = Nelixmo.SMS.text
      |> from("Test123")
      |> to("440101020304")
      |> message("Hello World")
      |> send_text

    assert result.from == "Test123"
    assert result.to == "440101020304"
    assert result.text == "Hello World"
  end

  test "send_text function" do
    result = Nelixmo.SMS.send_text(from: "Test123", to: "440101020304", message: "Hello World")
    assert result.from == "Test123"
    assert result.to == "440101020304"
    assert result.text == "Hello World"
  end

  test "send_unicode function" do
    result = Nelixmo.SMS.send_unicode(from: "Test123", to: "440101020304", message: "她脸上的香泽！")
    assert result.from == "Test123"
    assert result.to == "440101020304"
    assert result.text == "她脸上的香泽！"
  end
end
