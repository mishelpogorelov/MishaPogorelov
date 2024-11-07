using HorizonSideRobots

include("functions.jl")

function movesym!(robot, side)
    isborder(robot, inverse(side)) && (untildawn(robot, side); return)
    move!(robot, inverse(side))
    movesym!(robot, side)
    move!(robot, inverse(side))
end
