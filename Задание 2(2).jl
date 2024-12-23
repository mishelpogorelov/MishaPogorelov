using HorizonSideRobots
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
function untildawn3(robot , side)
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
        n = untildawn3(robot, i)
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
#Задача 6
using HorizonSideRobots
function untildawn2(robot , side)
    k = 0 
    while !isborder(robot, side)
        move!(robot, side)
        fillchamber(robot)
        k+=1
    end
    putmarker!(robot)
    return k
end
function untildawn1(robot , side)
    k = 0 
    while !isborder(robot, side)
        move!(robot, side)
        k+=1
    end
    return k
end

function perimetra(robot)
    height = 0
    sideln = 0
    while (!isborder(robot, Nord) || !isborder(robot, Ost))
        while !isborder(robot, Nord)
            move!(robot, Nord)
            height += 1
        end
        while isborder(robot, Nord)
            if !isborder(robot, Ost)
                move!(robot, Ost)
                sideln += 1
            else
                break
            end
        end

    end
    untildawn2(robot, Sud)
    untildawn2(robot, West)
    untildawn2(robot, Nord)
    untildawn2(robot, Ost)
    move!(robot, West, sideln)
    n = 0
    z = 0
    while n!= height
        while !isborder(robot, Sud)
            n+=1
            if n > height
                break
            end
            move!(robot, Sud)
            if n == height
                break
            end
        end
        otstup = 0
        if n == height
            break
        end
        while isborder(robot, Sud)
            if !isborder(robot, Ost)
                move!(robot, Ost)
                z+=1
                otstup += 1
            else
                break
            end
        end
        move!(robot, Sud)
        n+=1
        if n == height
            break
        end
        while isborder(robot, West)
            move!(robot, Sud)
            n+=1
            if n == height
                break
            end
        end
        move!(robot, West, z)
        z = 0
        if n == height
            break
        end
    end
end
function perimetrb(robot)
    height = 0
    sideln = 0
    while (!isborder(robot, Nord) || !isborder(robot, Ost))
        while !isborder(robot, Nord)
            move!(robot, Nord)
            height += 1
        end
        while isborder(robot, Nord)
            if !isborder(robot, Ost)
                move!(robot, Ost)
                sideln += 1
            else
                break
            end
        end

    end
    move!(robot, West, sideln)
    putmarker!(robot)
    move!(robot, Ost, sideln)
    move!(robot, Sud, height)
    putmarker!(robot)
    sud = untildawn1(robot, Sud)
    move!(robot, West, sideln)
    putmarker!(robot)
    west = untildawn1(robot, West)
    move!(robot, Nord, sud)
    putmarker!(robot)
    untildawn1(robot, Nord)
    untildawn1(robot, Ost)
    move!(robot, West, sideln)
    n = 0
    z = 0
    while n!= height
        while !isborder(robot, Sud)
            n+=1
            if n > height
                break
            end
            move!(robot, Sud)
            if n == height
                break
            end
        end
        otstup = 0
        if n == height
            break
        end
        while isborder(robot, Sud)
            if !isborder(robot, Ost)
                move!(robot, Ost)
                z+=1
                otstup += 1
            else
                break
            end
        end
        move!(robot, Sud)
        n+=1
        if n == height
            break
        end
        while isborder(robot, West)
            move!(robot, Sud)
            n+=1
            if n == height
                break
            end
        end
        move!(robot, West, z)
        z = 0
        if n == height
            break
        end
    end
end
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#Задача 7
using HorizonSideRobots
function move1!(robot, side, num_steps::Integer)
    for _ in 1 : num_steps
        if isborder(robot, Nord) || isborder(robot, Sud)
            move!(robot, side)
        end
    end
end
function findexit(robot)
    n= 0 
    while isborder(robot, Nord) || isborder(robot, Sud)
        n+=1
        move1!(robot, West, n)
        move1!(robot, Ost, 2*n)
        move1!(robot, West, n)
    end
end
#////////////////////////////////////////////////////////////////////////////////////////////////////
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
