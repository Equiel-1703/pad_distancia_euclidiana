use EuclideanDistance

argv = System.argv()

{str_dim, str_verbose} =
  case length(argv) do
    1 ->
      {System.argv() |> hd(), nil}

    2 ->
      {System.argv() |> hd(), System.argv() |> tl() |> hd()}

    _ ->
      IO.puts("Usage: mix run scripts/calculate_distances.exs DIM [-v|--verbose]")
      :erlang.halt(1)
  end

dim = str_dim |> String.to_integer()

if dim < 1 do
  IO.puts("DIM cannot be less than 1!")
  :erlang.halt(1)
end

verbose =
  case str_verbose do
    "-v" -> true
    "--verbose" -> true
    _ -> false
  end

# --- Creating lists with vector data ---

q_values = for _i <- 1..dim, do: 1.0

len_x = 3584
x_values = for i <- 1..len_x, do: Enum.map(q_values, fn e -> e * i end)

# --- Creating tensors from the lists ---

q_tensor = Nx.tensor(q_values, type: :f32)
x_tensor = Nx.tensor(x_values, type: :f32)

# --- Spawning kernel and measuring its time ---

{dists, time_ms} = EuclideanDistance.calculate_euclidean_distance(q_tensor, x_tensor, len_x, dim)

# --- Printing time and results ---

IO.puts("== Time took: #{time_ms}ms")
IO.puts("")
IO.puts("Vector dimension (T): #{dim}")
IO.puts("Size of X set (N): #{len_x}")
IO.puts("")
IO.inspect(q_values, label: "q")
IO.puts("")
IO.inspect(x_values, label: "X set")

if verbose do
  IO.puts("")

  Enum.with_index(dists, 1)
  |> Enum.map(fn {dist, idx} ->
    expected_val = :math.sqrt((idx * 1.0 - 1.0) ** 2 * dim)

    idx_formatted =
      Integer.to_string(idx)
      |> String.pad_leading(4)

    dist_formatted =
      :erlang.float_to_binary(dist, decimals: 3)
      |> String.pad_leading(8)

    expected_val_formatted =
      :erlang.float_to_binary(expected_val, decimals: 3)
      |> String.pad_leading(8)

    IO.puts("Dist #{idx_formatted}: #{dist_formatted} | Expected: #{expected_val_formatted}")
  end)
end
