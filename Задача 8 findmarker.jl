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
