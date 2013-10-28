defmodule PressureCache.Supervisor do
  use Supervisor.Behaviour

  def start_link(cache) do
    :supervisor.start_link(__MODULE__, [cache])
  end

  def init([cache]) do
    children = [
      worker(PressureCache.Server, [cache])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
