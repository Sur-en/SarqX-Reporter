defmodule John do
  def greet do
    receive do
      {sender, msg} ->
        IO.inspect(sender, label: :sender)
        IO.inspect(msg, label: :msg)
        send(sender, {:ok, "Hello Mark, I'm well what about you?"})
        greet()
    end
  end
end

defmodule Mark do
  def response do
    # here's a client
    pid = spawn(John, :greet, [])
    send(pid, {self(), "Hello John, how are you?"})

    receive do
      {:ok, message} ->
        IO.inspect(message, label: :Mark)
    end
  end
end

defmodule Job do
  import :timer, only: [sleep: 1]

  def sad do
    # sleep(3500)

    receive do
      {sender, msg} ->
        exit(:boom)

        IO.inspect(msg, label: :msg_of_rob)
        send(sender, "I'm well Rob")
        sad()
    end
  end
end

defmodule Rob do
  def run do
    Process.flag(:trap_exit, true)
    pid = spawn_link(Job, :sad, [])
    send(pid, {self(), "How are you sad Job? =D"})

    receive do
      msg ->
        IO.puts("MESSAGE RECEIVED: #{inspect(msg)}")
    after
      1000 ->
        IO.puts("Nothing happened as far as I am concerned")
    end
  end
end
