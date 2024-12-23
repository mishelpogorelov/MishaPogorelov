using HorizonSideRobots
function summa(massive, s)
    if isempty(massive)
        return s
    else
        return summa(massive[begin+1: end], s + massive[begin])
    end
end

