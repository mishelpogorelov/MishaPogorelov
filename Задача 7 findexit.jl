using HorizonSideRobots
function HorizonSideRobots.move!(robot, side, num_steps::Integer)
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
        move!(robot, West, n)
        move!(robot, Ost, 2*n)
        move!(robot, West, n)
    end
end
