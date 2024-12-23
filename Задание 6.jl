using HorizonSideRobots
#Задача 18
using HorizonSideRobots
include("functions.jl")
struct MarkRobot
    robot :: Robot
end
function move_border!(robot, side)
    !isborder(robot, side) && (move!(robot, side); return)
    move!(robot, right(side))
    move_border!(robot, side)
    move!(robot, left(side))
end
right(side::HorizonSide) = HorizonSide((Int(side)+3)%4)
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
        move_border!(robot.robot, side)
        n += 1
    end
    return stop_condition()
end
function findmarkera(robot)
    spiral!(s -> ismarker(robot.robot), robot)
end



function find_directb!(stop_condition :: Function, robot, side, nmax_steps)
    n = 0
    while stop_condition() == false && n < nmax_steps
        findempty(robot, side)
        n += 1
    end
    return stop_condition()
end

function spiralb!(stop_condition::Function, robot)
    nmax_steps = 1
    s = Nord
    while !find_directb!(()->stop_condition(s), robot, s, nmax_steps)
        (s in (Nord, Sud)) && (nmax_steps += 1)
        s = left(s)
    end
end


function shuttle!(stop_condition::Function, robot, start_side)
    s = start_side
    n = 0
    while !stop_condition(s)
        move!(robot.robot, s, n)
        s = inverse(s)
        n += 1
    end
    return n, s
end

function findempty(robot, side)
    n, s = shuttle!(s -> !isborder(robot.robot, side), robot, right(side))
    move!(robot.robot, side)
    move!(robot.robot, s, div(n, 2))
end




function findmarkerb(robot)
    spiralb!(s -> ismarker(robot.robot), robot)
end
#//////////////////////////////////////////////////////////////////////////////////////////////////
#Задача 19
using HorizonSideRobots
function movetoendrec0!(robot, side)
    !isborder(robot, side) && (move!(robot,side); movetoendrec0!(robot,side))
    return nothing
end
#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#Задача 20
using HorizonSideRobots
include("functions.jl")
function movetoendrec!(robot, side)
    if !isborder(robot, side)
        move!(robot, side) 
        !isborder(robot, side) &&movetoendrec!(robot,side)
    else
        putmarker!(robot)
        return nothing
    end
    if isborder(robot, side)   
        putmarker!(robot)
    end
    move!(robot, inverse(side))
end
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
