require PolyHok

PolyHok.defmodule EuclideanDistance do
  defd calculate_euclidean(vec_1, vec_2, dim) do
    res = 0.0

    for i in range(dim) do
      diff = vec_2[i] - vec_1[i]
      res = res + diff * diff
    end

    return(sqrt(res))
  end

  # q - vetor referencia
  # x - conjunto X contendo 'len_x' vetores
  defk euclidean_distance_kernel(q, x, len_x, num_dims, arr_results) do
    g_idx = get_global_id(0)
    x_idx = g_idx * num_dims

    if x_idx < len_x do
      arr_results[g_idx] = calculate_euclidean(q, x + x_idx, num_dims)
    end
  end

  def calculate_euclidean_distance(q, x, len_x, num_dims) do
    q_gnx = q |> PolyHok.new_gnx()
    x_gnx = x |> PolyHok.new_gnx()
    arr_results_gnx = PolyHok.new_gnx({len_x}, :f32)

    threads_per_block = 128
    num_blocks = div(len_x + threads_per_block - 1, threads_per_block)

    PolyHok.spawn(
      &EuclideanDistance.euclidean_distance_kernel/5,
      {num_blocks, 1, 1},
      {threads_per_block, 1, 1},
      [
        q_gnx,
        x_gnx,
        len_x,
        num_dims,
        arr_results_gnx
      ]
    )

    PolyHok.get_gnx(arr_results_gnx) |> Nx.to_list()
  end
end
