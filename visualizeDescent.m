figure(1), clf

tic 
% choose initial point
r = [0.0;0.0];

% generate the surface with lines and such
plot(r(1), r(2),'o')
hold on

[px,py]=meshgrid(0:0.1:2,0:0.1:2.5);
[xlim,ylim] = size(px);
V = zeros(xlim, ylim);

for i=1:xlim
    for j=1:ylim
          line = @(x0,m,xi,yi) log(sqrt(( px(i,j)-x0-xi).^2 + ((py(i,j)-(m.*x0)-yi).^2)));
          circle = @(xi,yi) log(sqrt((px(i,j)-xi).^2 + ((py(i,j)-yi).^2)));
          dV4 = @(x0)line(x0, -1,1.5,1);
          dV5 = @(x0)line(x0, 1,0.5,1.5);
          dV3 = @(x0)line(x0, 0.01,0,0);
          dV6 = @(x0)line(x0, 0.01,0,2.5);
          dV7 = @(x0)line(x0, -1,0,0);
          dV8 = @(x0)line(x0, 1000,2,0);
%           V(i,j) = integral(dV5,0.2,-0.2) + 2*integral(dV4,0.2,-0.2) + integral(dV3,4,-4) +...
%               integral(dV6,4,-4) + integral(dV7,4,-4)./3 + 6*integral(dV8,4,-4) + circle(1.75,2.25);
          V(i,j) = circle(1.75,2.25);
    end
end

% visualize contour and gradient plot of surface in advance
% (entirely for pretty plots)
contour3(px,py,V);
[Ex,Ey] = gradient(V);
axis equal
hold on
colorbar
quiver(px,py,-Ex,-Ey,'k');

% find the gradient at initial pt
xp = round(r(1),2);
yp = round(r(2),2);
[gx, gy] = gradGenerator(xp,yp);
grad = 30.*[-gx;-gy]


lambda = .25; % feet
delta = .99; % current delta
tolerance = .1; % gradient norm tolerance
orientation = [0;1]; %initial orientation

% calculate desired angle
angle = acos(dot(orientation, grad)./norm(grad));
orientation = grad./norm(grad);
time = 2*angle/(pi / 2);

norm(grad);
count = 1;

disp('gradient time')

while norm(grad) > tolerance
    if count < 13
        time = (lambda/3.281)/0.1;
        
        % update gradient, linear, and angle calculations
        r = r + lambda*grad./norm(grad);
        lambda = lambda*delta;
        xp = round(r(1),2);
        yp = round(r(2),2);
        [gx, gy] = gradGenerator(xp,yp);
        grad = 30.*[-gx;-gy];
        norm(grad);
        angle = acos(dot(orientation, grad)./norm(grad));
        orientation = grad./norm(grad);
        
        time = 2*angle/1.5748;
        
        plot(r(1), r(2),'bo');
        count = count+1;
    else
        break
    end
end

toc