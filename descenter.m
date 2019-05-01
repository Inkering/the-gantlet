
% r = [1;-1];
% f = x.*y-x.^2-y.^2-2.*x-2.*y+4;

% plots a ascent
r = [-0.65;-0.5];
[x,y] = meshgrid(-3:.01:1, -3:.01:1);
f = x.*y-x.^2-y.^2-2.*x-2.*y+4;
% contour(x,y,f)
% hold on;
plot(r(1), r(2),'o')
hold on
% performs an ascent, locking function
% in order to make it a descent, go the opposite way!

% setup a publisher
% pub = rospublisher('/raw_vel');
% message = rosmessage(pub);   

% find our gradient and scale
% [gx,gy] = gradient(f);
% grad = 100 .* [-gx(round(r(2),2)*100+301, round(r(1),2)*100+301);
%                -gy(round(r(2),2)*100+301, round(r(1),2)*100+301)];
xp = round(r(2),2)*100+301;
yp = round(r(1),2)*100+301;
[gx, gy] = gradGenerator(xp, yp);
grad = 100 .* [gx; gy];
lambda = .25; % feet
delta = .99; % current delta
tolerance = .01; % gradient norm tolerance
orientation = [0;1]; %initial orientation

% calculate current angle change necessary
angle = acos(dot(orientation, grad)./norm(grad));
orientation = grad./norm(grad);

% perform initial rotation
time = 2*angle/(pi / 2);
% message.Data = [-.1,.1];  
% send(pub, message);
% pause(time);
% message.Data = [0,0];
% send(pub,message);

% stop when the norm of the gradient is greater than tolerance
norm(grad)

while norm(grad) > tolerance
    norm(grad)
    %move distance lambda along gradient
    time = (lambda/3.281)/0.1;
%     message.Data = [.1,.1];
%     send(pub, message);
%     pause(time);
%     message.Data = [0,0];
%     send(pub,message);
    
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
%     message.Data = [-.1,.1];
%     send(pub, message);
    pause(time);
%     message.Data = [0,0];
%     send(pub,message);
    plot(r(1), r(2),'o')
end

% stop moving, we're done!
% message.Data = [0,0];
% send(pub,message);