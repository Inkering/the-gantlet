function output = driveangle(angle, speed, d)
% driveforward is a simple function that controls the NEATO to drive straight forward 
% at a designated speed for a set distance

%This line says we are going to publish to the topic `/raw_vel' 
%which are the left and right wheel velocities
pubvel = rospublisher('/raw_vel') 

%Here we are creating a ROS message
message = rosmessage(pubvel);

%in Matlab tic and toc start and stop a timer. In this program we are making sure we 
%drive the desired distance by finding the necessary time based on speed
tic 

%Set the right and left wheel velocities
message.Data = [-speed, speed];
w = (speed + speed) / d;
% Send the velocity commands to the NEATO
send(pubvel, message);
while 1
    if toc > angle/w % Here we are saying the if the elapsed time is greater than 
        %distance/speed, we have reached our desired distance and we should stop
        
        message.Data = [0,0]; % set wheel velocities to zero if we have reached the desire distance
        send(pubvel, message); % send new wheel velocities
        break %leave this loop once we have reached the stopping time
    end
end

end