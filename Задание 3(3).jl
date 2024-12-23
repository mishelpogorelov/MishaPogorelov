using HorizonSideRobots
#Задача 8
using HorizonSideRobots
include("functions.jl")
function oneside(robot, side, num_steps)
    if !ismarker(robot)
        for i in 1:num_steps
            if !ismarker(robot)
                move!(robot, side)
            end
        end 
    end
end
function quadro(robot, num_steps)
    move!(robot, Nord)
    if !ismarker(robot)
        oneside(robot, Ost, num_steps//2)
        oneside(robot, Sud, num_steps)
        oneside(robot, West, num_steps)
        oneside(robot, Nord, num_steps)
        oneside(robot, Ost, num_steps//2+1)
    end
end
function findmarker(robot)
    n = 1
    while !ismarker(robot)
        n+=2
        quadro(robot, n)
    end
end
#/////////////////////////////////////////////////////////////////////////////////////////////////////
#Задача 9
using HorizonSideRobots
    
function HorizonSideRobots.move!(robot, side, num_steps::Integer)
    for _ in 1:num_steps
        move!(robot, side)
    end
end      
        
  
inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)  


function fill(robot, side)
    untildawn(robot, side)
    if !isborder(robot, West)
        move!(robot, West)
    end
end
function chec(robot,side)
    while !isborder(robot, side)
        if ismarker(robot)
            move!(robot, side)
            if !isborder(robot, side)
                move!(robot, side)
                putmarker!(robot)
            end
        else
            move!(robot,side)
            putmarker!(robot)
        end
    end
end
function untildawn(robot , side)
    k = 0 
    while !isborder(robot, side)
        move!(robot, side)
        k+=1
    end
    return k
end
function chess(robot)
    putmarker!(robot)
    nord = untildawn(robot, Nord)
    west = untildawn(robot, West)
    sud = untildawn(robot, Sud)
    ost = untildawn(robot, Ost)
    move!(robot, West, ost - west)
    move!(robot, Nord, sud - nord)
    chec(robot, Nord)
    chec(robot, West)
    side = Sud
    for i in 1:ost
        chec(robot, side)
        if !isborder(robot, Ost)
            if ismarker(robot)
                move!(robot,Ost)
                side = inverse(side)
            else
                move!(robot, Ost)
                putmarker!(robot)
                side = inverse(side)
            end
        end
        chec(robot, side)
    end
    move!(robot, West, ost - west)
    if isborder(robot, Nord)
        move!(robot, Sud, nord)
    else
        move!(robot, Nord, sud - nord)
    end
end
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#Задача 10

using HorizonSideRobots
include("functions.jl")
function go_back!(robot)
    move!(robot, Nord)
    untildawn(robot, West)
end
function line!(robot, n, N)
    k = 0
    if div(n, N)%2 == 0
        while !isborder(robot, Ost)
            if div(k, N)%2 == 0
                putmarker!(robot)
                move!(robot, Ost)
                k+=1
            elseif div(k, N)%2 == 1
                move!(robot, Ost)
                k+=1
            end
        end
        if div(k, N)%2 == 0
            putmarker!(robot)
        end
    elseif div(n, N)%2 == 1
        while !isborder(robot, Ost)
            if div(k, N)%2 == 1
                putmarker!(robot)
                move!(robot,Ost)
                k+=1
            elseif div(k, N)%2 == 0
                move!(robot, Ost)
                k+=1
            end
        end
        if div(k, N)%2 == 1
            putmarker!(robot)
        end
    end
end

function chess_N(robot, N)
    num_steps_West = untildawn(robot, West)
    num_steps_Sud = untildawn(robot, Sud)
    n = 0
    while true
        line!(robot, n, N)
        if isborder(robot, Nord)
            break
        end
        go_back!(robot)
        n+=1
    end
    untildawn(robot, West)
    untildawn(robot, Sud)
    move!(robot, Nord, num_steps_Sud)
    move!(robot, Ost, num_steps_West)
end
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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