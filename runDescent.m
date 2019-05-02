% setup publisher / ros
pub = rospublisher('/raw_vel');
message = rosmessage(pub); 

% choose initial point
r = [1;1.5];

% generate the surface with lines and such
plot(r(1), r(2),'o')
hold on

[px,py]=meshgrid(0:0.1:2,0:0.1:2.5);
[xlim,ylim] = size(px);
V = zeros(xlim, ylim);

for i=1:xlim
    for j=1:ylim
        line = @(x0,m,xi,yi) log(sqrt((px(i,j)-x0-xi).^2 + ((py(i,j)-(m.*x0)-yi).^2)));
        dV2 = @(x0)line(x0, 0.01,1,0);
        dV3 = @(x0)line(x0, 1,1.75,2.25);
        dV4 = @(x0)line(x0, -1,1.5,1);
        dV5 = @(x0)line(x0, 1,0.5,1.5);
%         V(i,j) = 2*integral(dV5,0.2,-0.2) + 2*integral(dV4,0.2,-0.2) + -2*integral(dV3,0.2,-0.2) + 0.5*integral(dV2,1,-1);
        V(i,j) = circle(1.75,2.25);
    end
end

% visualize contour and gradient plot of surface in advance
% (entirely for pretty plots)
contour3(px,py,V)
[Ex,Ey] = gradient(V);
hold on
axis equal
colorbar
quiver(px,py,Ex,Ey)

% find the gradient at initial pt
xp = round(r(1),2);
yp = round(r(2),2);
[gx, gy] = gradGenerator(xp,yp);
grad = 30.*[-gx;-gy];

lambda = .25; % feet
delta = .99; % current delta
tolerance = .63; % gradient norm tolerance
orientation = [0;1]; %initial orientation

% calculate desired angle
angle = acos(dot(orientation, grad)./norm(grad));
orientation = grad./norm(grad);

% rotate to the correct initial angle
time = 2*angle/(pi / 2);
message.Data = [-.1,.1];  
send(pub, message);
pause(time);
message.Data = [0,0];
send(pub,message);

% initialize a counter and log current gradient length
norm(grad)
count = 1;

while norm(grad) > tolerance
    if count < 10
        % perform linear distance movement
        time = (lambda/3.281)/0.1;
        message.Data = [.1,.1];
        send(pub, message);
        pause(time);
        message.Data = [0,0];
        send(pub,message);
        
        % update gradient, linear, and angle calculations
        r = r + lambda*grad./norm(grad);
        lambda = lambda*delta;
        xp = round(r(1),2);
        yp = round(r(2),2);
        [gx, gy] = gradGenerator(xp,yp);
        grad = 30.*[-gx;-gy];
        norm(grad)
        angle = acos(dot(orientation, grad)./norm(grad));
        orientation = grad./norm(grad);
        
        % perform angular movement
        time = 2*angle/1.5748;
        message.Data = [-.1,.1];
        send(pub, message);
        pause(time);
        message.Data = [0,0];
        send(pub,message);

        plot(r(1), r(2),'o')
        count = count+1;
    else
        break
    end
end

% stop moving, we're done!
message.Data = [0,0];
send(pub,message);