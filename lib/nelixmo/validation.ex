defmodule Nelixmo.Validate do
  @moduledoc """
  Functions for validating values and requests made to Nexmo endpoints
  """

  @sender_id_regex Regex.compile!("^[a-zA-Z0-9]{1,11}$")
  @sender_number_regex Regex.compile!("^\\d{1,14}$")
  @e164_regex Regex.compile!("^\\+?\\d{10,14}$")

  @doc ~S"""
  Validates sender_id

  ## Example

      iex> Nelixmo.Validate.sender_id "447525856424"
      "447525856424"

      iex> Nelixmo.Validate.sender_id "447525856424_"
      {:error, :invalid_sender_id}
  """
  def sender_id(id) when is_binary(id) do
    if Regex.match?(@sender_number_regex, id) or Regex.match?(@sender_id_regex, id) do
      id
    else
      {:error, :invalid_sender_id}
    end
  end

  
  @doc ~S"""
  Validates a phone number

  ## Example

      iex> Nelixmo.Validate.phone_number "+447525856424"
      "+447525856424"

      iex> Nelixmo.Validate.phone_number "447525856424"
      "447525856424"

      iex> Nelixmo.Validate.phone_number "447525856424_"
      {:error, :invalid_phone_number}
  """
  def phone_number(number) when is_binary(number) do
    if Regex.match?(@e164_regex, number) do
      number
    else
      {:error, :invalid_phone_number}
    end
  end

  @doc ~S"""
  Validates a string for use in text message body

  ## Example

      iex> Nelixmo.Validate.text_message "轻声！"
      "轻声！"
  """
  def text_message(message) when is_binary(message) do
    message
  end

end
