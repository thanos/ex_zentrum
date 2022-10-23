defmodule Result do
  def wrap(m = {:ok, _}), do: m
  def wrap(m = {:error, _}), do: m

  def wrap(nil), do: error
  def wrap(:error), do: error
  def wrap(v), do: ok(v)

  def unwrap({t, v}) when t in [:ok, :error], do: unwrap(v)
  def unwrap(x), do: x

  def ok(v), do: {:ok, unwrap(v)}

  def error, do: {:error, nil}
  def error(r), do: {:error, unwrap(r)}
end