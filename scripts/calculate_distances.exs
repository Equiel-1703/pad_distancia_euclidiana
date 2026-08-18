use EuclideanDistance

argv = System.argv()

if length(argv) != 1 do
  IO.puts "Usage: mix run scripts/calculate_distances.exs DIM"
  :erlang.halt(1)
end

dim = System.argv() |> hd() |> String.to_integer()

if dim < 1 do
  IO.puts "DIM cannot be less than 1!"
  :erlang.halt(1)
end

# --- Creating lists with vector data ---

q_values = for _i <- 1..dim, do: 1.0

len_x = 3584
x_values = for i <- 1..len_x, do: Enum.map(q_values, fn e -> e * i end)

# --- Creating tensors from the lists ---

q_tensor = Nx.tensor(q_values, type: :f32)
x_tensor = Nx.tensor(x_values, type: :f32)

# --- Spawning kernel and measuring its time ---

start_t = System.monotonic_time()

dists = EuclideanDistance.calculate_euclidean_distance(q_tensor, x_tensor, len_x, dim)

end_t = System.monotonic_time()
time_ms = System.convert_time_unit(end_t - start_t, :native, :millisecond)

# --- Printing time and results ---

IO.puts("Time took: #{time_ms}ms\n")
IO.puts("Vector dimension: #{dim}")
IO.inspect(q_values, label: "q - reference vector")
IO.puts("Size of X set: #{len_x}")
IO.inspect(x_values, label: "X set")

Enum.with_index(dists, 1) |> Enum.map(fn {dist, idx} -> IO.puts("Dist #{idx}: #{dist}") end)
