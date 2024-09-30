using HorizonSideRobots
include("functions.jl")
function untildawn1(robot , side)
    k = 0 
    while !isborder(robot, side)
        move!(robot, side)
        fillchamber(robot)
        k+=1
    end
    putmarker!(robot)
    return k
end

function perimetr(robot)
    n = untildawn1(robot, Nord)
    m = untildawn1(robot, West)
    for s in (Sud, Ost, Nord, West)
        untildawn1(robot, s)
    end
    move!(robot,Sud, n)
    move!(robot, Ost, m)
end
