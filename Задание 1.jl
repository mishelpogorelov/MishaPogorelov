using HorizonSideRobots
#Задача 1
using HorizonSideRobots
function cross!(robot)
    for side in (Nord, Ost, Sud, West)
        num_steps = mark_direct!(robot, side)
        side = inverse(side)
        move!(robot, side, num_steps)
    end
end
function HorizonSideRobots.move!(robot, side, num_steps::Integer)
    for _ in 1:num_steps
        move!(robot, side)
    end
end
inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)
n = 0
function mark_direct!(robot, side)
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
        n+=1
    end
    return n
end
#////////////////////////////////////////////////////////////////////////////////////////////////////////////
#Задача 2
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
#//////////////////////////////////////////////////////////////////////////////////////////////////////////
#Задача 3
using HorizonSideRobots
include("functions.jl")
function untildawn2(robot , side)
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
    untildawn2(robot, side)
    if !isborder(robot, West)
        move!(robot, West)
    end
end 

function filling(robot)
    sp = []
    for s in (Nord, West, Sud, Ost)
        n = untildawn2(robot, s)
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
        move!(robot, Nord, abs(sp[3] - sp[1]))
    end
end
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////
#Задача 4
using HorizonSideRobots
include("functions.jl")
HorizonSideRobots.isborder(robot, side::NTuple{2, HorizonSide}) = (isborder(robot, side[1]) || isborder(robot, side[2]))
HorizonSideRobots.move!(robot, side::Any) = for s in side move!(robot, s) end
function mark_direct!(robot, side)
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        n+=1
        putmarker!(robot)
    end
    return n
end
function diagonalcross(robot)
    sides= ((Nord, Ost), (Sud, Ost), (Sud, West), (Nord, West))
    putmarker!(robot)
    for s = sides
        n = mark_direct!(robot, s)
        move!(robot, inverse.(s), n)
    end
        
end
#Задача 5
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
            while isborder(robot, West)
                move!(robot, side)
            end
            move!(robot, inverse(side))
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

right(side::HorizonSide) = HorizonSide((Int(side)+3)%4)


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
    for i in [West, Sud, Ost, Nord]
        quadroside(robot, i, right(i))
        if i !=  Nord
            move!(robot, i)
        end
    end
    untildawn(robot, Sud)
    untildawn(robot, Ost)
    move!(robot, Nord, sp[3]-sp[1])
    move!(robot, West, sp[4]-sp[2])
end
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#functions
using HorizonSideRobots
function HorizonSideRobots.move!(robot, side, num_steps::Integer)
    for _ in 1 : num_steps
        move!(robot, side)
    end
end
inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)
n = 0
function mark_direct!(robot, side)
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
        n+=1
    end
    return n
end
function untildawn(robot , side)
    k = 0 
    while !isborder(robot, side)
        move!(robot, side)
        k+=1
    end
    return k
end
function fillchamber(robot)
    for side in (Nord, Ost, Sud, West)
        if isborder(robot, side)
            putmarker!(robot)
        end
    end
end
