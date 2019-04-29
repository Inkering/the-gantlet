%% gradient ascent
r0 = [1,-1];
r = @(x,y) x.*y - x^2 - y^2 -2.*x - 2.*y + 4;

dx = @(x)-2-2*x(1)+x(2);
dy = @(x)-2-2*x(2)+x(1);
gradient = [dx(r0),dy(r0)];

points = r0;

mag = norm(gradient);
threshold = .1;
lambda = 1/20;
delta = 1.2;
theta = 0 %pi / 2;

i = 1;
while mag > threshold
    ri = points(i,:) + lambda*gradient;
    lambda = lambda*delta;
    gradient = [dx(ri),dy(ri)];
    mag = norm(gradient);
    points = [points;ri];
    
    dist = vecnorm(points(i,:)-ri);
    x = ri(1) - points(i,1);
    y = ri(2) - points(i,2);
    theta = atan(abs(x/y))-theta;
    
    % positive angle we want to turn ccw
    driveangle(theta, 0.1, 0.254)
    driveforward(dist*0.3048, 0.1)

    i = i+1;
end

disp('All Done!')
figure()
ezcontour(r,[-3,1]), hold on
plot(points(:,1),points(:,2))
axis equal
xlabel('x (ft)')
ylabel('y (ft)')
