
function fiba(k)
    sp = [0, 1, 1]
    for i in range(3, k)
        push!(sp, sp[i-1] + sp[i-2])
    end
    return sp[k]
end

function fibb(k)
    if k == 0
        return 0
    elseif (k == 1 || k == 2)
        return 1
    else
        return fibb(k-1) + fibb(k-2)
    end
end

using Memoize
@memoize function fibc(k)
    if k == 0
        return 0
    elseif k in (1,2)
        return 1
    else
        return fibc(k-1)+fibc(k-2)
    end
end



