% setup publisher / ros
% pub = rospublisher('/raw_vel');
% message = rosmessage(pub); 

% goodpoints = [[0.23,0.23],[0.23,0.23];[0.23,0.23],[0.23,0.23]];
A = [0,0];
B = [1,1];
goodpoints = [A,B];

numlines = size(goodpoints, 1);

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
        for h=1:numlines
            theLine = goodpoints(h,:);
            vec = [theLine(1),theLine(2)] - [theLine(3),theLine(4)];
            startx = theLine(1);
            starty = theLine(2);
            slope = vec(1) / vec(2);
            line = @(x0,m,xi,yi) log(sqrt((px(i,j)-x0-xi).^2 + ((py(i,j)-(m.*x0)-yi).^2)));
            lined = @(x0)line(x0, slope,startx,starty);
            V(i,j) = V(i,j) + integral(lined,0,norm(vec));
        end
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
% message.Data = [-.1,.1];  
% send(pub, message);
% pause(time);
% message.Data = [0,0];
% send(pub,message);

% initialize a counter and log current gradient length
norm(grad)
count = 1;

while norm(grad) > tolerance
    if count < 10
        % perform linear distance movement
        time = (lambda/3.281)/0.1;
%         message.Data = [.1,.1];
%         send(pub, message);
%         pause(time);
%         message.Data = [0,0];
%         send(pub,message);
        
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
%         message.Data = [-.1,.1];
%         send(pub, message);
%         pause(time);
%         message.Data = [0,0];
%         send(pub,message);

        plot(r(1), r(2),'o')
        count = count+1;
    else
        break
    end
end

% stop moving, we're done!
% message.Data = [0,0];
% send(pub,message);