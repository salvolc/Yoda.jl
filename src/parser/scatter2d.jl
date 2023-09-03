#This is specific to Rivet analyses, not general 2D scatter plots in YODA format 
function give_scatter_names(file_lbl)
    histogram_names = []
    for i in 1:length(file_lbl)
        line = file_lbl[i]
        if occursin("YODA_SCATTER2D_V2",line) && occursin("BEGIN",line)
            push!(histogram_names,split(line)[3])
        end
    end
    return histogram_names
end

function give_scatter(i,file_lbl,histogram_names=give_ref_histogram_names(file_lbl))
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

        if histblock && occursin("# xval",line)
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
    Histogram(vcat(data[1,:].-data[2,:],data[1,end]+data[3,end]),data[4,:])
end

function get_all_scatter_to_mc(filename,filename_mc)
    io_mc = open(filename_mc, "r")
    file_string_mc = read(io_mc,String)
    file_lbl_mc = split(file_string_mc,"\n")
    names_mc = give_histogram_names(file_lbl_mc)
    get_all_scatter_to_names(filename,names_mc)
end

function get_all_scatter_to_names(filename,names_mc)
    io = open(filename, "r")
    file_string = read(io,String)
    file_lbl = split(file_string,"\n")
    names = give_scatter_names(file_lbl)

    ind = []
    for n in 1:length(names)
        if(sum(occursin.(Ref(string(split(names[n],"/")[end-1],"/",split(names[n],"/")[end])),names_mc)) > 0)
            push!(ind,n)
        end
    end

    histograms = [give_scatter(i,file_lbl,names) for i in ind]
    names = [names[i] for i in ind]
    return hcat(names,histograms)
end

function get_all_scatter(filename)
    io_mc = open(filename, "r")
    file_string_mc = read(io_mc,String)
    file_lbl_mc = split(file_string_mc,"\n")
    names_mc = give_scatter_names(file_lbl_mc)
    histograms = [give_scatter(i,file_lbl_mc,names_mc) for i in 1:length(names_mc)]
    return hcat(names_mc,histograms)
end


function give_scatter_err(i,file_lbl,histogram_names=give_ref_histogram_names(file_lbl)) #yerr smmetric for Rivet analyses
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

        if histblock && occursin("# xval",line)
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
    return data[5,:]
end

function get_scatter_err_to_mc(filename,filename_mc)
    io_mc = open(filename_mc, "r")
    file_string_mc = read(io_mc,String)
    file_lbl_mc = split(file_string_mc,"\n")
    names_mc = give_histogram_names(file_lbl_mc)
    get_scatter_err_to_names(filename,names_mc)
end

function get_scatter_err_to_names(filename,names_mc)
    io = open(filename, "r")
    file_string = read(io,String)
    file_lbl = split(file_string,"\n")
    names = give_ref_histogram_names(file_lbl)

    ind = []
    for n in 1:length(names)
        if(sum(occursin.(Ref(string(split(names[n],"/")[end-1],"/",split(names[n],"/")[end])),names_mc)) > 0)
            push!(ind,n)
        end
    end

    histograms = [give_scatter_err(i,file_lbl,names) for i in ind]
    names = [names[i] for i in ind]
    return hcat(names,histograms)
end

function get_all_scatter_err(filename)
    io_mc = open(filename, "r")
    file_string_mc = read(io_mc,String)
    file_lbl_mc = split(file_string_mc,"\n")
    names_mc = give_scatter_names(file_lbl_mc)
    histograms = [give_scatter_err(i,file_lbl_mc,names_mc) for i in 1:length(names_mc)]
    return hcat(names_mc,histograms)
end
