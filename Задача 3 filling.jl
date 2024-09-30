using HorizonSideRobots
include("functions.jl")
function untildawn1(robot , side)
    k = 0 
    while !isborder(robot, side)
        putmarker!(robot)
        move!(robot, side)
        putmarker!(robot)
        k+=1
    end
    return k
end

function fill(robot, side)
    untildawn1(robot, side)
    if !isborder(robot, West)
        move!(robot, West)
    end
end 

function filling(robot)
    sp = []
    for s in (Nord, West, Sud, Ost)
        n = untildawn1(robot, s)
        push!(sp, n)
    end
    side = Nord
    for i in 1:sp[4]
        fill(robot, side)
        side = inverse(side)
    end
    move!(robot, Ost, sp[2])
    if isborder(robot, Nord)
        move!(robot, Sud, sp[1])
    else
        move!(robot, Nord, sp[3] - sp[4])
    end
end

