defmodule SarqXReporter.Help do
  def execute do
    IO.puts("Usage: SarqX CLI [OPTION]")
    IO.puts("  --help \t display help message")
    IO.puts("  --status \t status application's demon")
    IO.puts("  --enable \t enable application's demon")
    IO.puts("  --disable \t disable application's demon")
    IO.puts("  --start \t start application's demon")
    IO.puts("  --stop \t stop application's demon")
    IO.puts("  --connect \t connect to the SarqX web-server")
  end
end
