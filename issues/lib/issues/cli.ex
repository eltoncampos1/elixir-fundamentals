defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
    Handle the command line parsing and
    the dispatch to the various of the last _n_ issues in a github project
  """

  def run(argv) do
    argv
    |> parse_args()
    |> process()
    |> decode_response()
    |> sort_in_descending_order()
  end

  def sort_in_descending_order(list_of_issues) do
    list_of_issues
    |> Enum.sort(fn i1, i2 ->
      i1["created_at"] >= i2["created_at"]
    end)
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, reason}) do
    IO.puts("Error fetching from Github: #{reason["message"]}")
    System.halt(2)
  end

  def process(:help) do
    IO.puts("""
        usage: issues <user> <project> [count | #{@default_count}]
    """)

    System.halt(0)
  end

  def process({user, project, _count}) do
    Issues.GithubIssues.fetch(user, project)
  end

  @doc """
   `argv` can b -h or --help, wich returns :help.

   Otherwise it is a github username, project name, and (optionally)
   the number of entries to format.

   Return a tuple of `{ user, project, count}`, or
   `:help` if help was given
  """

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  def args_to_internal_representation([user, project]) do
    {user, project, @default_count}
  end

  def args_to_internal_representation(_), do: :help
end
