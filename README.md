# ExDynamodbLocal

This is a very simplistic wrapper to download and run DynamodbLocal.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_dynamodb_local` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_dynamodb_local, "~> 0.1.0"}
  ]
end
```

Via Github:
```elixir
def deps do
  [
    {:ex_dynamodb_local, git: "https://github.com/Tout/ex_dynamodb_local.git", tag: "0.1.0", only: [:dev, :test]}

  ]
end
```

## Configuration

You can specify where to install or find the dynamldb_local executables. Add to your `config/dev.exs` and `config/test.exs` files:

```elixir
config :ex_dynamodb_local,
  db_path: <path/to/executable> # defaults to /priv
```

## Use

You can start dynamodb_local:
Note: if executable is not found, it will try to download it first.
```elixir
ExDynamodbLocal.start
```

You can stop dynamodb_local:
```elixir
ExDynamodbLocal.stop
```

You can check if dynamodb_local is running:
```elixir
ExDynamodbLocal.connected?
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_dynamodb_local](https://hexdocs.pm/ex_dynamodb_local).

