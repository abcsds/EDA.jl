module EDA

export eda

function sample_sort!(sample)
    sample = sample[sortperm(sample[:,end]),:]
end

function eda(obj;
             sample_size=100,
             μ=0,
             σ=1,
             dimensions=2,
             select_ratio=0.5,
             max_iter=100,
             ϵ=10e-6)

    means = []
    stdevs = []
    debug = false

    # uniform initialization
    sample = [rand(sample_size, dimensions) .* σ .+ μ zeros(sample_size)]
    sample[:,end] = mapslices(obj,sample[:,1:dimensions],(1,2))  # Evaluate

    # main loop
    for _ in 1:max_iter
        # _____dispersion_reduction()
        # select survivors
        sample_sort!(sample)
        nb = Int(floor(sample_size * select_ratio))
        sample = sample[1:nb,:]

        # _____estimate_parameters()
        # points sub array (without values)
        mat = sample[:, 1:dimensions]
        # row means (axis 0 in scipy)
        means = mean(mat, 2)
        # row standard deviation
        stdevs = std(mat, 2)
        map(x -> x==0.0?ϵ:x, stdevs) # Remove zeros from stdevs


        # _____draw_sample()
        sample = Float64[]
        for i in 1:sample_size
            sample = vcat(sample, [(rand(dimensions) .* stdevs[i%nb+1] .+ means[i%nb+1]).' 0])
        end

        # _____evaluate()
        sample[:,end] = mapslices(obj,sample[:,1:dimensions],(1,2))
    end

    # sort the final sample
    sample_sort!(sample)
    # output the optimum
    println("#[ x y f(x,y) ]")
    println(sample[1,:])
end

end  # module EDA
