defmodule PressureCache.Supervisor do
  use Supervisor.Behaviour

  def start_link([cache, path]) do
    :supervisor.start_link(__MODULE__, [cache, path])
  end

  def init([cache, path]) do

    backend = case :os.type do
      { :unix, :linux }  -> :inotifywait
      { :unix, :darwin } -> :fsevents
      _                  -> throw(:os_not_supported)
    end

    case backend.find_executable do
      false -> throw(:executable_not_found)
      _     -> :ok
    end

    children = [
      worker(:erlfsmon_server, [backend, path, bitstring_to_list(File.cwd!)]),
      worker(:gen_event, [{:local, :erlfsmon_events}]),
      worker(PressureCache.Server, [[cache, path]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
