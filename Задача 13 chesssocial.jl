using HorizonSideRobots

include("functions.jl")
mutable struct ChessRobot
    robot::Robot
    flag::Bool
end
function HorizonSideRobots.move!(robot::ChessRobot, side)
    robot.flag && putmarker!(robot.robot)
    robot.flag  = !robot.flag
    move!(robot.robot, side)
end

function movetoend!(stop_condition::Function, robot, side)
    n=0
    while !stop_condition()
        move!(robot, side)
        n+=1
    end
    robot.flag && putmarker!(robot.robot)
    return n
end


function snake!(stop_condition::Function, robot, sides::NTuple{2,HorizonSide})
    s=sides[1]
    k = 0
    while !stop_condition(s)
        movetoend!(()->stop_condition(s) || isborder(robot.robot, s), robot,s)
        if stop_condition(s)
            break
        end
    s = inverse(s)
    move!(robot, sides[2])
    end
end

function chess(robot)
    k = untildawn(robot.robot, Nord)
    n = untildawn(robot.robot, West)
    move!(robot.robot, Sud, k)
    move!(robot.robot, Ost, n)
    putmarker!(robot.robot)
    snake!( s -> isborder(robot.robot, Nord) && isborder(robot.robot, s), robot, (West, Nord))
    snake!( s -> isborder(robot.robot, Sud) && isborder(robot.robot, s), robot, (Ost, Sud))
    untildawn(robot.robot, Nord)
    untildawn(robot.robot, West)
    move!(robot.robot, Sud, k)
    move!(robot.robot, Ost, n)
end

