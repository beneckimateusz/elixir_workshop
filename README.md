# ElixirWorkshop

## Running release
To start application execute following command:
```bash
RELEASE_DISTRIBUTION=name RELEASE_NODE=workshop@public_ip RELEASE_COOKIE=secret_cookie _build/dev/rel/elixir_workshop/bin/elixir_workshop start
```
Remember to replace `public_ip` and `secret_cookie` with respective values  

Additionaly machine must allow incomming traffic on TCP ports:  
4369 (epmd) and a range 30000 - 64000 (probably, the best is to check ouptut of `epmd -names`).  
If you want to be precautious, you can first start server, then check port that it registered on in epmd and open only this port.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `elixir_workshop` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixir_workshop, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/elixir_workshop>.

