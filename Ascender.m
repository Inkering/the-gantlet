
r = [1;-1];
f = x.*y-x.^2-y.^2-2.*x-2.*y+4;

plsplot(r,f)
plsascend(r, f)

function output = plsplot(r,f)
% plots a ascent
[x,y] = meshgrid(-3:.01:1, -3:.01:1);
contour(x,y,f)
hold on;
plot(r(1), r(2),'o')
end

function output = plsascend(r, f)
% performs an ascent, locking

% setup a publisher
pub = rospublisher('/raw_vel');
message = rosmessage(pub);   

% find our gradient and scale
[gx,gy] = gradient(f);
grad = 100 .* [gx(round(r(2),2)*100+301, round(r(1),2)*100+301);
               gy(round(r(2),2)*100+301, round(r(1),2)*100+301)];
lambda = .25; % feet
delta = .99; % current delta
tolerance = 0.09; % gradient norm tolerance
orientation = [0;1]; %initial orientation

% calculate current angle change necessary
angle = acos(dot(orientation, grad)./norm(grad));
orientation = grad./norm(grad);

% perform initial rotation
time = 2*angle/(pi / 2);
message.Data = [-.1,.1];
send(pub, message);
pause(time);
message.Data = [0,0];
send(pub,message);

% stop when the norm of the gradient is greater than tolerance
while norm(grad) > tolerance
    norm(grad)
    %move distance lambda along gradient
    time = (lambda/3.281)/0.1;
    message.Data = [.1,.1];
    send(pub, message);
    pause(time);
    message.Data = [0,0];
    send(pub,message);
    
    %calculate new position
    r = r + lambda*grad./norm(grad);
    
    %calculate new lamba
    lambda = lambda*delta;
    
    %find gradient at new position
    grad = 100.*[gx(round(r(2),2)*100+301, round(r(1),2)*100+301);
    gy(round(r(2),2)*100+301, round(r(1),2)*100+301)];

    %calculate angle between orientation and gradient
    angle = acos(dot(orientation, grad)./norm(grad));
    orientation = grad./norm(grad);
    
    %rotate said angle
    time = 2*angle/1.5748;
    message.Data = [-.1,.1];
    send(pub, message);
    pause(time);
    message.Data = [0,0];
    send(pub,message);
    plot(r(1), r(2),'o')
end

% stop moving, we're done!
message.Data = [0,0];
send(pub,message);

end