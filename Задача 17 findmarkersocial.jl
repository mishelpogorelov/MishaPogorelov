
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

