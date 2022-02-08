defmodule SarqXReporter.CLITest do
  use ExUnit.Case
  doctest SarqXReporter

  test "Test main" do
    # IO.inspect(SarqXReporter.CLI.main(["--help"]))
  end

  test "Test parse_args" do
    assert SarqXReporter.CLI.parse_args(["--help"]) === [help: true]
    assert SarqXReporter.CLI.parse_args(["--enable"]) === [{:enable, true}]
    assert SarqXReporter.CLI.parse_args(["--disable"]) === [{:disable, true}]
    assert SarqXReporter.CLI.parse_args(["--start"]) === [{:start, true}]
    assert SarqXReporter.CLI.parse_args(["--stop"]) === [{:stop, true}]
    assert SarqXReporter.CLI.parse_args([]) === []
  end
end
