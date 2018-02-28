defmodule ExDynamodbLocal.Installer do
  require Logger

  import ExDynamodbLocal.Util

  # defaults
  @jar_filename Application.get_env(:ex_dynamodb_local, :jar_filename, "DynamoDBLocal.jar")
  @latest_jar_url Application.get_env(:ex_dynamodb_local, :latest_jar_url, "https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_latest.tar.gz")

  def setup_dynamodb_local do
    File.mkdir_p(db_path())

    is_executable_available =
      @jar_filename
      |> db_path
      |> File.exists?

    case is_executable_available do
      true -> Logger.info("DynamoDBLocal is already setup!")
      false -> download_and_extract()
    end
  end

  def download_and_extract do
    download()
    extract()
  end

  defp download do
    Logger.info "- Downloading latest dynamodb_local"
    Download.from(@latest_jar_url, [path: db_path(src_filename())])
  end

  defp extract do
    Logger.info "- Extracting latest dynamodb_local"
    System.cmd("tar", ["-xzf#{src_filename()}"], [cd: db_path()])
  end

  defp src_filename do
    @latest_jar_url
      |> String.split("/")
      |> List.last
  end
end