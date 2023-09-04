export get_all_histograms
export get_all_sumw2
export get_all_errs

function get_all_histograms(filename)
    io = open(filename, "r")
    file_string = read(io,String)
    file_lbl = split(file_string,"\n")
    names = give_histogram_names(file_lbl)
    histograms = [give_histogram(i,file_lbl,names) for i in 1:length(names)]
    return hcat(names,histograms)
end

function give_histogram_names(file_lbl)
    histogram_names = []
    for i in 1:length(file_lbl)
        line = file_lbl[i]
        if occursin("HISTO1D",line) && occursin("BEGIN",line)
            push!(histogram_names,split(line)[3])
        end
    end
    return histogram_names
end

function give_histogram(i,file_lbl,histogram_names=give_histogram_names(file_lbl))
    histblock=false
    datablock=false
    data = []

    for j in 1:length(file_lbl)
        line = file_lbl[j]

        if occursin("BEGIN",line)
            if histogram_names[i] == split(line)[3]
                histblock = true
            end
        end

        if histblock && occursin("# xlow",line)
            datablock=true
            continue
        end

        if occursin("END",line)
            histblock=false
            datablock=false
        end

        if datablock
            push!(data,parse.(Float64,split(line,"\t")))
        end
    end
    data = hcat(data...)
    binl = data[2,:] .- data[1,:]
    Histogram(vcat(data[1,:],data[2,length(data[1,:])]),data[3,:]./binl)
end

function give_sumw2(i,file_lbl,histogram_names=give_histogram_names(file_lbl),unweighted=false)
    histblock=false
    datablock=false
    data = []
    for j in 1:length(file_lbl)
        line = file_lbl[j]
        if occursin("BEGIN",line)
            if histogram_names[i] == split(line)[3]
                histblock = true
            end
        end
        if histblock && occursin("# xlow",line)
            datablock=true
            continue
        end
        if occursin("END",line)
            histblock=false
            datablock=false
        end
        if datablock
            push!(data,parse.(Float64,split(line,"\t")))
        end
    end
    data = hcat(data...)
    binl = data[2,:] .- data[1,:]
    data[4,:]
end

function get_all_sumw2(filename)
    io = open(filename, "r")
    file_string = read(io,String)
    file_lbl = split(file_string,"\n")
    names = give_histogram_names(file_lbl)
    histograms = [give_sumw2(i,file_lbl,names) for i in 1:length(names)]
    return hcat(names,histograms)
end

function give_errs(i,file_lbl,histogram_names=give_histogram_names(file_lbl),unweighted=false)
    histblock=false
    datablock=false
    data = []
    for j in 1:length(file_lbl)
        line = file_lbl[j]
        if occursin("BEGIN",line)
            if histogram_names[i] == split(line)[3]
                histblock = true
            end
        end
        if histblock && occursin("# xlow",line)
            datablock=true
            continue
        end
        if occursin("END",line)
            histblock=false
            datablock=false
        end
        if datablock
            push!(data,parse.(Float64,split(line,"\t")))
        end
    end
    data = hcat(data...)
    binl = data[2,:] .- data[1,:]
    sqrt.(data[4,:]) ./ binl
end

function get_all_errs(filename)
    io = open(filename, "r")
    file_string = read(io,String)
    file_lbl = split(file_string,"\n")
    names = give_histogram_names(file_lbl)
    histograms = [give_errs(i,file_lbl,names) for i in 1:length(names)]
    return hcat(names,histograms)
end

function give_full_hist_raw(i,file_lbl,histogram_names=give_histogram_names(file_lbl),unweighted=false) #for testing purposes
    histblock=false
    datablock=false
    data = []
    for j in 1:length(file_lbl)
        line = file_lbl[j]
        if occursin("BEGIN",line)
            if histogram_names[i] == split(line)[3]
                histblock = true
            end
        end
        if histblock && occursin("# xlow",line)
            datablock=true
            continue
        end
        if occursin("END",line)
            histblock=false
            datablock=false
        end
        if datablock
            push!(data,parse.(Float64,split(line,"\t")))
        end
    end
    data = hcat(data...)
    binl = data[2,:] .- data[1,:]
    data
end

function get_all_full_hist_raw(filename)
    io = open(filename, "r")
    file_string = read(io,String)
    file_lbl = split(file_string,"\n")
    names = give_histogram_names(file_lbl)
    histograms = [give_full_hist_raw(i,file_lbl,names) for i in 1:length(names)]
    return hcat(names,histograms)
end