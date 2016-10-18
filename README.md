# Nelixmo

Elixir client for the [Nexmo](https://www.nexmo.com/) communications platform.

Still very much a "work in progress" though it does have tests, docs, doctests,  validation and both a piped and simple function based API.

Currently only supports SMS text messaging (including unicode)


## Generate dev config:
    touch config/dev.exs
    
Put your development API key and secret in this file (see `config/test.exs` for an example).
Or use `NEXMO_API_KEY` & `NEXMO_API_SECRET` environment variables

## Generate and open docs:
    mix deps.get
    mix docs
    open doc/index.html

## Run tests and generate coverage report:
    MIX_ENV=test mix coveralls.html
    open cover/excoveralls.html

## Example usage (pipe style)

```elixir
import Nelixmo.SMS

Nelixmo.SMS.text
  |> from("MyCompany20")
  |> to("447525856424")
  |> message("Hello Nexmo")
  |> send_text
```

Building messages like this allows you to reuse partially built message structures e.g:

```elixir
defmodule AccountAlerts do
  import Nelixmo.SMS

  @account_alert unicode
    |> options(status_report_req: true, client_ref: "acct_alert")
    |> from("BankCo")

  def send_balance_alert(user) do
    @account_alert
      |> to(user.phone_number)
      |> message("#{user.first_name}: your balance is #{user.balance}.")
      |> send_text
  end

  def send_payment_alert(user, payment) do
    @account_alert
      |> to(user.phone_number)
      |> message("#{user.first_name}: your account has been credited #{payment.total}.")
      |> send_text
  end
end
```
## Example usage (function style)

```elixir
Nelixmo.SMS.send_text(from: "MyCompany20", to: "447525856424", message: "Hello Nexmo")
```

## Example response

```elixir
%{
  message_count: 1,
  messages: [%Nelixmo.HTTP.Message.Response {
    error_text: nil,
    id: "08000000173AF786", network: "23420", price: 0.0333,
    remaining_balance: 21.5005, status: 0, to: "447525856424"
  }]
}
```
 
## Installation (TODO: not yet available in Hex)

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `nelixmo` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:nelixmo, "~> 0.1.0"}]
    end
    ```

  2. Ensure `nelixmo` is started before your application:

    ```elixir
    def application do
      [applications: [:nelixmo]]
    end
    ```

