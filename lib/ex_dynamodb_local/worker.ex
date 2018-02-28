defmodule ExDynamodbLocal.Worker do
  require Logger

  import ExDynamodbLocal.Util

  # defaults
  @jar_filename Application.get_env(:ex_dynamodb_local, :jar_filename, "DynamoDBLocal.jar")
  @lib_path Application.get_env(:ex_dynamodb_local, :lib_path, "DynamoDBLocal_lib")
  @in_memory Application.get_env(:ex_dynamodb_local, :in_memory, false)
  @port Application.get_env(:ex_dynamodb_local, :port)


  @doc """
    Starts dynamodb_local. Unless the process is already running.
    If the executable is not found, is downloaded and extracted.
  """
  def start_if_not_running do
    case read_pid() do
      "" -> start()
      pid -> pid
    end
  end

  @doc """
    Stops dynamodb_local. Kills the external process, unless the process is not running.
  """
  def stop_if_running do
    case read_pid() do
      "" -> nil
      _pid -> stop()
    end
  end

  defp start do
    lib_path = @lib_path |> db_path()
    jar_path = @jar_filename |> db_path()

    options = [
      "-Djava.library.path=#{lib_path}",
      "-jar",
      jar_path
    ]

    options = db_path() && options ++ ["-dbPath", db_path()] || options
    options = @in_memory && options ++ ["-inMemory", @in_memory] || options
    options = @port && options ++ ["-port", "#{@port}"] || options

    executable_path = System.find_executable("java")
    port = Port.open({:spawn_executable, executable_path}, [:binary, args: options])
    # TODO: investigate how to kill port when pid terminates
    # Process.link(port)
    # Port.connect(port, self())
    pid = Port.info(port) |> Keyword.get(:os_pid)
    IO.inspect port
    Logger.info "dynamodb_local started with PID: #{pid}"
    pid
  end

  defp stop do
    kill_process()
  end

  defp kill_process do
    Logger.debug "Killing dynamodb_local process"
    os_pid = read_pid()
    System.cmd("kill", ["-9", os_pid], [])
  end

end