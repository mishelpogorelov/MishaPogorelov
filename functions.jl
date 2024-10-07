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

