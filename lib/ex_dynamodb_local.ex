defmodule ExDynamodbLocal do
  alias ExDynamodbLocal.Server
  @moduledoc """
  Documentation for ExDynamodbLocal.
  """

  @doc """
    Installs and starts dynamodb_local
  """
  def start do
    Server.start
  end

  @doc """
    Checks if dynamodb_local is running
  """
  def connected? do
    Server.connected?
  end

  @doc """
    Stops dynamodb_local
  """
  def stop do
    Server.stop
  end
end
