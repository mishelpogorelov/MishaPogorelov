function allsubtypes(T, k)
    sp = subtypes(T)
    for i in eachindex(sp)
        print(supertype(sp[i]), string(repeat(" ", k),subtypes(sp[i])), string(repeat("//", k)))
        allsubtypes(sp[i], k)
    end
end
