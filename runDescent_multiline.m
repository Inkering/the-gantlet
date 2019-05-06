clf, figure(1), hold on
% setup publisher / ros
% % pub = rospublisher('/raw_vel');
% % message = rosmessage(pub); 

% log
disp("Generating map")
tic 
% positions of line objects
% % goodpoints = [[0.23,0.23],[0.23,0.23];[0.23,0.23],[0.23,0.23]];
% A = [1.4,1.25];
% B = [1.85,0.44];
% C = [0.4,1.5];
% D = [0.8,1.64];
% E = [-1,1];
% F = [1,-1];
% goodpoints = [A,B;
%               C,D;
%               E,F];

% bucket position
cx = 1.21;
cy = 2;

% lines
goodpoints = RANSAC_map();
%goodpoints(end+1, = 

numlines = size(goodpoints, 1);

% choose initial point
r = [0.25;0.25];
plot(r(1), r(2),'o'), hold on

% mesh for whole map
[px,py]=meshgrid(0:0.1:1.75,0:0.1:2.5);
[xlim,ylim] = size(px);
V = zeros(xlim, ylim);

% build gradient for plotting the entire map
for i=1:xlim
    for j=1:ylim
        current = 0;
        for h=1:numlines
            theLine = goodpoints(h,:);
            vec = [theLine(1),theLine(2)] - [theLine(3),theLine(4)];
            startx = theLine(1);
            starty = theLine(2);
            slope = vec(2) ./ vec(1);
            line = @(x0,m,xi,yi) log(sqrt((px(i,j)-x0-xi).^2 + ((py(i,j)-(m.*x0)-yi).^2)));
            circle = @(xi,yi) log(sqrt((px(i,j)-xi).^2 + ((py(i,j)-yi).^2)));
            lined = @(x0)line(x0, slope,startx,starty);
            current = current - 0.1*integral(lined,0,norm(vec(1)));
        end
        V(i,j) = current + circle(cx,cy);
    end
end

% visualize contour and gradient plot of surface in advance
% (entirely for pretty plots)

contour(px,py,V,20);
[Ex,Ey] = gradient(V);
axis equal
hold on
colorbar
quiver(px,py,-Ex,-Ey,'k');

% log
toc
disp("Descending")
tic
% find the gradient at initial pt
xp = round(r(1),2);
yp = round(r(2),2);
[gx, gy] = gradGenerator_multiline(xp,yp, goodpoints, cx, cy);
grad = 100*[-gx;-gy];

lambda = .25; % feet
delta = .99; % current delta
tolerance = .01; % gradient norm tolerance
orientation = [0;1]; %initial orientation

% calculate desired angle
angle = acos(dot(orientation, grad)./norm(grad));
orientation = grad./norm(grad);

% rotate to the correct initial angle
time = 2*angle/(pi / 2);
% % message.Data = [-.1,.1];
% % send(pub, message);
% % pause(time);
% % message.Data = [0,0];
% % send(pub,message);

% initialize a counter and log current gradient length
norm(grad)
count = 1;

while norm(grad) > tolerance
    if count < 9
        % perform linear distance movement
        time = (lambda/3.281)/0.1;
% %         message.Data = [.1,.1];
% %         send(pub, message);
% %         pause(time);
% %         message.Data = [0,0];
% %         send(pub,message);
        
        % update gradient, linear, and angle calculations
        r = r + lambda*grad./norm(grad);
        lambda = lambda*delta;
        xp = round(r(1),2);
        yp = round(r(2),2);
        [gx, gy] = gradGenerator_multiline(xp,yp, goodpoints, cx, cy);
        grad = 100.*[-gx;-gy];
        norm(grad);
        angle = acos(dot(orientation, grad)./norm(grad));
        orientation = grad./norm(grad);
        
        % perform angular movement
        time = 2*angle/1.5748;
% %         message.Data = [-.1,.1];
% %         send(pub, message);
% %         pause(time);
% %         message.Data = [0,0];
% %         send(pub,message);
        
        % plot the current theoretical location
        plot(r(1), r(2),'ko')
        count = count+1;
    else
        break
    end
end

toc
disp("Its over!")
% stop moving, we're done!
% % message.Data = [0,0];
% % send(pub,message);