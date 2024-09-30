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
    move!(robot, Sud, nord)
end
