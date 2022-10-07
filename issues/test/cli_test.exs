defmodule CLITest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI

  test ":help returned by otion parsing with -h and -help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "coutn is defaulted if two values given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end

  test "sort descending orders the correct way" do
    result = sort_in_descending_order(fake_list(["a", "b", "c"]))
    issues = for issue <- result, do: Map.get(issue, "created_at")

    assert issues == ~w{c b a}
  end

  def fake_list(values) do
    for value <- values, do: %{"created_at" => value, "other_data" => "xxx"}
  end
end
