defmodule SarqXReporter.Token do
  @secret Application.get_env(:sarqx_reporter, :secret)
  @salt Application.get_env(:sarqx_reporter, :salt)

  def sign(data) do
    Plug.Crypto.sign(@secret, @salt, data)
  end
end
