# Estimation of Distribution Algorithm
Evolutive algorithm for stochastic optimization. https://link.springer.com/book/10.1007%2F978-1-4615-1539-5

```julia
using EDA: eda
obj(x) = sum(x.^2,2) # x_1^2 + x_2^2 + ... + x_n^2 Convex function

@time eda(obj;
          sample_size=100,
          μ=50,
          σ=5,
          dimensions=2,
          select_ratio=0.5,
          max_iter=100,
          ϵ=10e-6)
```
