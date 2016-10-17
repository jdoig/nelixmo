defmodule Nelixmo.Validate do
  @moduledoc """
  Functions for validating values and requests made to Nexmo endpoints
  """

  @sender_id_regex ~r"^[a-zA-Z0-9]{1,11}$"
  @sender_number_regex ~r"^\d{1,14}$"
  @e164_regex ~r"^\+?\d{10,14}$"
  @url ~r"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)"

  @doc ~S"""
  Validates sender_id

  ## Example

      iex> Nelixmo.Validate.sender_id "447525856424"
      {:ok, "447525856424"}

      iex> Nelixmo.Validate.sender_id "447525856424_"
      {:error, :invalid_sender_id}
  """
  def sender_id(id) when is_binary(id) do
    if Regex.match?(@sender_number_regex, id) or Regex.match?(@sender_id_regex, id) do
      {:ok, id}
    else
      {:error, :invalid_sender_id}
    end
  end

  
  @doc ~S"""
  Validates a phone number

  ## Example

      iex> Nelixmo.Validate.phone_number "+447525856424"
      {:ok, "+447525856424"}

      iex> Nelixmo.Validate.phone_number "447525856424"
      {:ok, "447525856424"}

      iex> Nelixmo.Validate.phone_number "447525856424_"
      {:error, :invalid_phone_number}
  """
  def phone_number(number) when is_binary(number) do
    if Regex.match?(@e164_regex, number) do
      {:ok, number}
    else
      {:error, :invalid_phone_number}
    end
  end

  @doc ~S"""
  Validates a string for use in text message body

  ## Example

      iex> Nelixmo.Validate.text_message "轻声！"
      {:ok, "轻声！"}
  """
  def text_message(message) when is_binary(message) do
    {:ok, message}
  end

  @doc """
  Validates a url

  ## Example

      iex> Nelixmo.Validate.url "https://example.com/callback"
      {:ok, "https://example.com/callback"}
  """
  def url(url) do
    if Regex.match?(@url, url) do
      {:ok, url}
    else
      {:error, :invalid_url}
    end
  end

  @doc """
  Cast
   `true` -> 1,
   `false` -> 0,
   `<= 0` -> 0,
   `> 0` -> 1

  ## Example

      iex> Nelixmo.Validate.bool_int true
      {:ok, 1}

      iex> Nelixmo.Validate.bool_int false
      {:ok, 0}

      iex> Nelixmo.Validate.bool_int 0
      {:ok, 0}

      iex> Nelixmo.Validate.bool_int -1
      {:ok, 0}

      iex> Nelixmo.Validate.bool_int 1
      {:ok, 1}

      iex> Nelixmo.Validate.bool_int 99
      {:ok, 1}

  """
  def bool_int(bool_int) when is_boolean(bool_int), do: {:ok, if(bool_int, do: 1, else: 0)}
  def bool_int(bool_int) when is_integer(bool_int), do: {:ok, if(bool_int > 0, do: 1, else: 0)}

  
  @doc """
  Checks client_ref is less than or equal to 40 characters.
  """
  def client_ref(ref) when is_binary(ref) do
    if String.length(ref) <= 40 do
      {:ok, ref}
    else
      {:error, :client_ref_too_long}
    end
  end

end
