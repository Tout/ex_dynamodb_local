defmodule ExDynamodbLocal.Server do
  require Logger
  use GenServer

  alias ExDynamodbLocal.Installer
  alias ExDynamodbLocal.Worker
  import ExDynamodbLocal.Util

  ## Client API

  @doc """
  Starts the server.
  """
  def start_link(_opts) do
    {:ok, pid} = GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
    # For debugging purposes:
    # :sys.statistics(pid, true)
    # :sys.trace(pid, true)
    {:ok, pid}
  end

  @doc """
    Starts the dynamodb_local process.
  """
  def start do
    GenServer.call(__MODULE__, :start_dynamodb_local)
  end

  @doc """
    Checks that the dynamodb_local process is running.
  """
  def connected? do
    GenServer.call(__MODULE__, :connected?)
  end

  @doc """
    Stops the dynamodb_local process.
  """
  def stop do
    GenServer.call(__MODULE__, :terminate)
  end

  ## Server Callbacks

  @doc """
    Calls start to spawn dynamodb_local process when the Worker is initialized.
  """
  def init(:ok) do
    os_pid = start_dynamodb_local()
    {:ok, os_pid}
  end

  @doc """
    Starts dynamodb_local. Unless the process is already running.
    If the executable is not found, is downloaded and extracted.
  """
  def handle_call(:start_dynamodb_local, _from, _state) do
    os_pid = start_dynamodb_local()
    {:reply, os_pid, os_pid}
  end

  @doc """
    Stops dynamodb_local. Kills the external process
  """
  def handle_call(:terminate, _from, _state) do
    Worker.stop_if_running()
    Logger.info "DynamodbLocal has stopped"
    {:reply, "", ""}
  end

  @doc """
    Checks if the dynamodb_local process exists.
  """
  def handle_call(:connected?, _from, _state) do
    case read_pid() do
      "" -> {:reply, false, ""}
      pid -> {:reply, true, pid}
    end
  end

  @doc """
    Prints information sent by dynamodb_local
  """
  def handle_info({_from, {:data, _message}}, state) do
    # Logger.debug message
    {:noreply, state}
  end

  def handle_info(_msg, state) do
    # IO.inspect msg
    {:noreply, state}
  end

  defp start_dynamodb_local do
    Logger.info "Initializing dynamodb_local"
    Installer.setup_dynamodb_local()
    Worker.start_if_not_running()
  end

end