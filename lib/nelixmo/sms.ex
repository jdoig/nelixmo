defmodule Nelixmo.SMS.Text do
  @moduledoc false
  defstruct [:sender, :recipient, :message, :type, :options]
end

defmodule Nelixmo.SMS.Options do
  @moduledoc false
  defstruct [:client_ref, :status_report_req, :callback]
end

defmodule Nelixmo.SMS do
  @moduledoc """
  Functions for building and sending SMS requests.
  """

  @doc """
  Returns an empty `Nelixmo.SMS.text` struct with the `:type` set to `"text"`

  ## Example 
        iex> Nelixmo.SMS.text
        %Nelixmo.SMS.Text{message: nil, recipient: %Nelixmo.Recipient{number: nil},
        sender: %Nelixmo.Sender{id: nil}, type: "text", options: nil}


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
  Returns an empty `Nelixmo.SMS.text` struct with the `:type` set to `"unicode"`

  ## Example
        iex> Nelixmo.SMS.unicode
        %Nelixmo.SMS.Text{message: nil, recipient: %Nelixmo.Recipient{number: nil},
        sender: %Nelixmo.Sender{id: nil}, type: "unicode", options: nil}


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
        sender: %Nelixmo.Sender{id: "MyCompany20"}, type: "text", options: nil}

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
    {:ok, id} = Nelixmo.Validate.sender_id sender_id
    sender = struct Nelixmo.Sender, [id: id]
    put_in(request.sender, sender)
  end

  
  @doc """
  Takes a `Nelixmo.SMS.text|binary|wappush|vcal|vcard` struct and an [E.164 compliant international phone `number`](https://en.wikipedia.org/wiki/E.164)

  Returns the passed in struct with the `number` validated and inserted.

  ## Example 
        iex> Nelixmo.SMS.text |> Nelixmo.SMS.to("447525856424")
        %Nelixmo.SMS.Text{message: nil, recipient: %Nelixmo.Recipient{number: "447525856424"},
        sender: %Nelixmo.Sender{id: nil}, type: "text", options: nil}


 ## Example usage

        import Nelixmo.SMS
        
        Nelixmo.SMS.text
          |> from("MyCompany20")
          |> to("447525856424")
          |> message("Hello Nexmo")

  """
  def to(request, number) do
    {:ok, phone_number} = Nelixmo.Validate.phone_number number
    recipient = struct Nelixmo.Recipient, [number: phone_number]
    put_in(request.recipient, recipient)
  end


  @doc """
  Takes a `Nelixmo.SMS.text|vcal|vcard` struct and string to use as the `text` message

  Returns the passed in struct with the `text` url encoded and inserted.

  ## Example 
        iex> Nelixmo.SMS.text |> Nelixmo.SMS.message("Hello world")
        %Nelixmo.SMS.Text{message: "Hello world", recipient: %Nelixmo.Recipient{number: nil},
        sender: %Nelixmo.Sender{id: nil}, type: "text", options: nil}


 ## Example usage

        import Nelixmo.SMS
        
        Nelixmo.SMS.text
          |> from("MyCompany20")
          |> to("447525856424")
          |> message("Hello Nexmo")

  """  
  def message(request, text) do
    {:ok, message} = Nelixmo.Validate.text_message text
    put_in(request.message, message) # this should fail if request type does not support text
  end

  @doc """
  Takes a `Nelixmo.SMS.text` struct and a map of `options`

  Returns the passed in struct with options inserted as Nelixmo.SMS.Options

  ## Example
     iex> Nelixmo.SMS.text |> Nelixmo.SMS.options(client_ref: "MyRef123", status_report_req: 1, callback: "https://example.com/callback")
     %Nelixmo.SMS.Text{message: nil,
       options: %Nelixmo.SMS.Options{callback: "https://example.com/callback",
       client_ref: "MyRef123", status_report_req: 1},
       recipient: %Nelixmo.Recipient{number: nil}, sender: %Nelixmo.Sender{id: nil},
       type: "text"}
  """
  def options(request, opts) do
    options = struct(Nelixmo.SMS.Options, opts)
    if Map.get(options, :callback), do: {:ok, _} = Nelixmo.Validate.url options.callback
    if Map.get(options, :client_ref), do: {:ok, _} = Nelixmo.Validate.client_ref options.client_ref
    if Map.get(options, :status_report_req), do: {:ok, _} = Nelixmo.Validate.bool_int options.status_report_req
    put_in(request.options, options)
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

  @doc """
  Shorthand for:

      Nelixmo.SMS.unicode
        |> from(sender)
        |> to(recipient)
        |> message(message)
        |> send_text
   """
  def send_unicode(from: sender, to: recipient, message: message) do
    unicode
    |> from(sender)
    |> to(recipient)
    |> message(message)
    |> send_text
  end

end
