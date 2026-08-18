use EuclideanDistance

num_dims = 3
len_x = 1

q = Nx.tensor([2.0, -1.0, 3.0], type: :f32)
x = Nx.tensor([[5.0, 3.0, 15.0]], type: :f32)

start_t = System.monotonic_time()

dists = EuclideanDistance.calculate_euclidean_distance(q, x, len_x, num_dims)

end_t = System.monotonic_time()
time_ms = System.convert_time_unit(end_t - start_t, :native, :millisecond)

IO.puts("Time took: #{time_ms}ms\n")
IO.inspect(q |> Nx.to_list(), label: "q")
IO.inspect(x |> Nx.to_list(), label: "x")

Enum.with_index(dists, 1) |> Enum.map(fn {dist, idx} -> IO.puts("Dist #{idx}: #{dist}") end)
