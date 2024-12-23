using HorizonSideRobots

include("functions.jl")

function moveminus!(robot, side)
    isborder(robot, side) && return
    move!(robot, side)
    moveplus!(robot, side)
    end
function moveplus!(robot, side)
    putmarker!(robot)
    isborder(robot, side) && return
    move!(robot, side)
    moveminus!(robot, side)
end
