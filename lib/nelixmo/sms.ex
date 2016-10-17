defmodule Nelixmo.SMS.Text do
  @moduledoc false
  defstruct [:sender, :recipient, :message, :type]
end

defmodule Nelixmo.SMS do
  @moduledoc """
  Functions for building and sending SMS requests.
  """

  @doc """
  Returns an empty `Nelixmo.SMS.text` struct

  ## Example 
        iex> Nelixmo.SMS.text
        %Nelixmo.SMS.Text{message: nil, recipient: %Nelixmo.Recipient{number: nil},
        sender: %Nelixmo.Sender{id: nil}, type: "text"}


  ## Example usage

        import Nelixmo.SMS
        
        Nelixmo.SMS.text
          |> from("MyCompany20")
          |> to("447525856424")
          |> message("Hello Nexmo")
  """
  def text do
    struct Nelixmo.SMS.Text, [sender: struct(Nelixmo.Sender), recipient: struct(Nelixmo.Recipient), type: "text"]
  end

  @doc """
  Returns an empty `Nelixmo.SMS.text` struct

  ## Example
        iex> Nelixmo.SMS.unicode
        %Nelixmo.SMS.Text{message: nil, recipient: %Nelixmo.Recipient{number: nil},
        sender: %Nelixmo.Sender{id: nil}, type: "unicode"}


  ## Example usage

        import Nelixmo.SMS

        Nelixmo.SMS.text
          |> from("MyCompany20")
          |> to("447525856424")
          |> message("Hello Nexmo")
  """
  def unicode do
    struct Nelixmo.SMS.Text, [sender: struct(Nelixmo.Sender), recipient: struct(Nelixmo.Recipient), type: "unicode"]
  end


  @doc """
  Takes a `Nelixmo.SMS.text|binary|wappush|vcal|vcard` struct and a [`sender_id`](https://docs.nexmo.com/messaging/sms-api/building-global-apps#senderID)

  Returns the passed in struct with the `sender_id` validated and inserted.

  ## Example 
        iex> Nelixmo.SMS.text |> Nelixmo.SMS.from("MyCompany20")
        %Nelixmo.SMS.Text{message: nil, recipient: %Nelixmo.Recipient{number: nil},
        sender: %Nelixmo.Sender{id: "MyCompany20"}, type: "text"}

  ## Example usage

        import Nelixmo.SMS
        
        Nelixmo.SMS.text
          |> from("MyCompany20")
          |> to("447525856424")
          |> message("Hello Nexmo")


  ## Sender ID

  * Numeric - up to a 15 digit telephone number in international format without a leading `+` or `00`
  * Alphanumeric - up to an 11 character string made up of the following supported characters: `abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789`
  """
  def from(request, sender_id) do
    id = Nelixmo.Validate.sender_id sender_id
    sender = struct Nelixmo.Sender, [id: id]
    put_in(request.sender, sender)
  end

  
  @doc """
  Takes a `Nelixmo.SMS.text|binary|wappush|vcal|vcard` struct and an [E.164 compliant international phone `number`](https://en.wikipedia.org/wiki/E.164)

  Returns the passed in struct with the `number` validated and inserted.

  ## Example 
        iex> Nelixmo.SMS.text |> Nelixmo.SMS.to("447525856424")
        %Nelixmo.SMS.Text{message: nil, recipient: %Nelixmo.Recipient{number: "447525856424"},
        sender: %Nelixmo.Sender{id: nil}, type: "text"}


 ## Example usage

        import Nelixmo.SMS
        
        Nelixmo.SMS.text
          |> from("MyCompany20")
          |> to("447525856424")
          |> message("Hello Nexmo")

  """
  def to(request, number) do
    phone_number = Nelixmo.Validate.phone_number number
    recipient = struct Nelixmo.Recipient, [number: phone_number]
    put_in(request.recipient, recipient)
  end


  @doc """
  Takes a `Nelixmo.SMS.text|vcal|vcard` struct and string to use as the `text` message

  Returns the passed in struct with the `text` url encoded and inserted.

  ## Example 
        iex> Nelixmo.SMS.text |> Nelixmo.SMS.message("Hello world")
        %Nelixmo.SMS.Text{message: "Hello world", recipient: %Nelixmo.Recipient{number: nil},
        sender: %Nelixmo.Sender{id: nil}, type: "text"}


 ## Example usage

        import Nelixmo.SMS
        
        Nelixmo.SMS.text
          |> from("MyCompany20")
          |> to("447525856424")
          |> message("Hello Nexmo")

  """  
  def message(request, text) do
    message = Nelixmo.Validate.text_message text
    put_in(request.message, message) # this should fail if request type does not support text
  end


  @doc """
  Takes a `Nelixmo.SMS.text` call the Nexmo SMS api with it.
  returns the response body on success
  """
  def send_text(request) when is_map(request) do
    Nelixmo.HTTP.SMS.send_text request
  end

  @doc """
  Shorthand for:

      Nelixmo.SMS.text
        |> from(sender)
        |> to(recipient)
        |> message(message)
        |> send_text
   """
  def send_text(from: sender, to: recipient, message: message) do
    text
    |> from(sender)
    |> to(recipient)
    |> message(message)
    |> send_text
  end

end
