using HorizonSideRobots
#Задача 15
using HorizonSideRobots

include("functions.jl")

struct Coords 
    x::Int64 
    y::Int64
end

mutable struct CoordRobots
    robot::Robot
    coords::Coords
end

function trymove!(robot, side)
    
    if !isborder(robot.robot, side)
        move!(robot, side)
        return true
    end
    false
end

function moves!(robot, side::HorizonSide)
    k = 0
    while !isborder(robot.robot, side)
        move!(robot, side)
        k += 1
    end
    return k
end

function movetoend!(robot)
    x0, y0 = 0, 0
    while !isborder(robot.robot, Sud) || !isborder(robot.robot, West)
        if !isborder(robot.robot, Sud)
            move!(robot, Sud)
            y0 += 1
        end
        if !isborder(robot.robot, West)
            move!(robot, West)
            x0 += 1
        end

    end 

    y = moves!(robot, Nord)
    x = moves!(robot, Ost)
    moves!(robot, Sud)
    moves!(robot, West)
    return x0, y0, x, y
end

function HorizonSideRobots.move!(coords::Coords, side::HorizonSide)
    x, y = coords.x, coords.y
    side == Nord && (y += 1)
    side == Sud && (y -= 1)
    side == West && (x -= 1)
    side == Ost && (x += 1)
    return Coords(x, y)
end

function HorizonSideRobots.move!(robot::CoordRobots, side::HorizonSide)
    move!(robot.robot, side)
    robot.coords = move!(robot.coords, side)
    abs(robot.coords.x) == abs(robot.coords.y) && putmarker!(robot.robot)
end

function snake!(robot, x, (move_side, next_row_side)::NTuple{2,HorizonSide} = (Ost,Nord))
    
    while !isborder(robot.robot, next_row_side) || !isborder(robot.robot, move_side)
        x_count = 0
       

        while x_count<x
            y_count = 0
            while !isborder(robot.robot, move_side)
                move!(robot, move_side)
                x_count += 1
            end
            
            if x_count < x
                while isborder(robot.robot, move_side)
                    move!(robot, Sud)
                    y_count += 1
                end
                
                move!(robot, move_side)
                x_count += 1

                while isborder(robot.robot, Nord)
                    move!(robot, move_side)
                    x_count += 1
                end

                for _ in 1:y_count
                    move!(robot, Nord)
                end

            end
        end

        if trymove!(robot, next_row_side)
            move_side = inverse(move_side)
        end

    end

end



function cross!(robot)
    x0, y0, x, y = movetoend!(robot)
    snake!(robot, x)
    movetoend!(robot)
    return!(robot, x0, y0)
end

function bord(robot)
    x, y = 0, 1
    while isborder(robot.robot, Nord)
        move!(robot.robot, West)
        x += 1
    end
    move!(robot.robot, Nord)
    while isborder(robot.robot, Ost)
        move!(robot.robot, Nord)
        y += 1
    end
    for _ in 1:x
        move!(robot.robot, Ost)
    end
    return y

end

function return!(robot, x0, y0)

    for _ in 1:x0
        move!(robot.robot, Ost)
    end

    while y0>0

        if !isborder(robot.robot, Nord)
            move!(robot.robot, Nord)
            y0 -= 1
        else
            k = bord(robot)
            y0 -= k
        end
    
    end
end
#Задача 16
include("functions.jl")
function shuttle1!(stop_condition::Function, robot, start_side)
    s = start_side
    n = 0
    while !stop_condition(s)
        move!(robot, s, n)
        s = inverse(s)
        n += 1
    end
end
function findexit(robot)
    shuttle1!(s->(!isborder(robot, Nord)), robot, West)
end
#////////////////////////////////////////////////////////////////////////////////////////
#Задача 17
using HorizonSideRobots
include("functions.jl")
struct MarkRobot
    robot :: Robot
end
left(side::HorizonSide) = HorizonSide((Int(side)+1)%4)
function spiral!(stop_condition::Function, robot)
    nmax_steps = 1
    s = Nord
    while !find_direct!(()->stop_condition(s), robot, s, nmax_steps)
        (s in (Nord, Sud)) && (nmax_steps += 1)
        s = left(s)
    end
end

function find_direct!(stop_condition :: Function, robot, side, nmax_steps)
    n = 0
    while stop_condition() == false && n < nmax_steps
        move!(robot.robot, side)
        n += 1
    end
    return stop_condition()
end
function findmarker(robot)
    spiral!(s -> ismarker(robot.robot), robot)
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
