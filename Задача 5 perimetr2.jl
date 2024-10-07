using HorizonSideRobots
include("functions.jl")
function untildawn1(robot , side)
    k = 0
    fillchamber(robot) 
    while !isborder(robot, side)
        k+=1
        move!(robot, side)
        fillchamber(robot)
    end
    putmarker!(robot)
    return k
end
function findborder(robot, side, n)
    k = 0
    for i in 1:n
        if isborder(robot, West)
            k = 1
            break
        else
            move!(robot, side)
        end
    end
    if !isborder(robot, West)
        move!(robot, West)
    end
    return k
end
function quadroside(robot, side, side1)
    while isborder(robot, side)
        fillchamber(robot)
        move!(robot, side1)
        fillchamber(robot)
    end
end
inversen(side::HorizonSide) = HorizonSide((Int(side)+1)%4)

function perimetr2(robot)
    sp = []
    for i in [Nord, West, Sud, Ost, Nord, West, Sud, Ost]
        n = untildawn1(robot, i)
        push!(sp, n)
    end
    k = 0
    side = Nord
    while k == 0
        k = findborder(robot, side, sp[7])
        side = inverse(side)
    end
    quadroside(robot, West, Nord)
    move!(robot, West)
    quadroside(robot, Sud, West)
    move!(robot, Sud)
    quadroside(robot, Ost, Sud)
    move!(robot, Ost)
    quadroside(robot, Nord, Ost)
    untildawn(robot, Sud)
    untildawn(robot, Ost)
    move!(robot, Nord, sp[3]-sp[1])
    move!(robot, West, sp[4]-sp[2])
end
