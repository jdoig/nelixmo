defmodule NelixmoValidateTest do
  use ExUnit.Case
  doctest Nelixmo.Validate

  test "sender_id as Numeric" do
    assert Nelixmo.Validate.sender_id("447525856424") == {:ok, "447525856424"}
  end

  test "sender_id as Alphanumeric" do
    assert Nelixmo.Validate.sender_id("MyCompany20") == {:ok, "MyCompany20"}
  end

  test "sender_id as Alphanumeric but too long" do
    assert Nelixmo.Validate.sender_id("MyCompany201") == {:error, :invalid_sender_id}
  end

  test "sender_id as Numeric but too long" do
    assert Nelixmo.Validate.sender_id("447525856420000") == {:error, :invalid_sender_id}
  end

  test "sender_id as Alphanumeric with bad chars" do
    assert Nelixmo.Validate.sender_id("MyCompany20_") == {:error, :invalid_sender_id}
  end

  test "sender_id as Numeric with bad chars" do
    assert Nelixmo.Validate.sender_id("_4475258564200") == {:error, :invalid_sender_id}
  end

  test "phone number with + prefix validates" do
    assert Nelixmo.Validate.phone_number("+447525856424") == {:ok, "+447525856424"}
  end
  
  test "phone number without + prefix validates" do
    assert Nelixmo.Validate.phone_number("447525856424") == {:ok, "447525856424"}
  end

  test "phone number with bad chars fails to validate" do
    assert Nelixmo.Validate.phone_number("_447525856424") == {:error, :invalid_phone_number}
  end

  test "phone number with too many numbers fails to validate" do
    assert Nelixmo.Validate.phone_number("44752585642400000") == {:error, :invalid_phone_number}
  end

  test "text message URI encodes" do
    assert Nelixmo.Validate.text_message("HelloWorld") == {:ok, "HelloWorld"}
    assert Nelixmo.Validate.text_message("Hello World") == {:ok, "Hello World"}
  end

end
