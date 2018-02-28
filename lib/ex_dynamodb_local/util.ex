defmodule ExDynamodbLocal.Util do
  
  def db_path(filename \\"") do
    Application.get_env(:ex_dynamodb_local, :db_path, Application.app_dir(:ex_dynamodb_local, "priv"))
      |> Path.join(filename)
  end

  def read_pid do
    {pid_string, _} = System.cmd("pgrep", ["-f", "Dynamo"], [])
    String.trim(pid_string)
  end

end
