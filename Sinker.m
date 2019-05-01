%% symbolic computation - round sinks
clf 

figure()
[X,Y] = meshgrid([-5:0.342:5],[-3:0.342:5]);
[X1,Y1] = meshgrid([-5:1.142:5],[-3:1.142:5]);

syms x y 
f = log(sqrt((x-0.2)^2 + y^2)) + log(sqrt((x-3)^2 + y^2)) + log(sqrt((x-1)^2 + (y-0.5)^2)) - log(sqrt((x-2)^2 + (y+2)^2))
g = gradient(f, [x,y])

hold off
contour3(X,Y,subs(f,[x,y],{X,Y}))
G1 = subs(g(1),[x,y],{X1,Y1});
G2 = subs(g(2),[x,y],{X1,Y1});
hold on
quiver(X1,Y1,G1,G2)
axis equal

%% symbolic computation - line sinks
clf 

figure()
[X,Y] = meshgrid([-6:0.342:6],[-6:0.342:6]);
[X1,Y1] = meshgrid([-6:1.142:6],[-6:1.142:6]);

syms x y x0
fa = int(sqrt((x-x0)^2 + (y)^2),x0)
f1 = -0.75 * (subs(fa,[x0],{-4}) - subs(fa,[x0],{4}))
f = 6 * log(sqrt((x + 2)^2 + (y+2)^2)) - f1
g = gradient(f, [x,y]) 

hold off
contour3(X,Y,subs(f,[x,y],{X,Y}))
G1 = subs(g(1),[x,y],{X1,Y1});
G2 = subs(g(2),[x,y],{X1,Y1});
hold on
quiver(X1,Y1,G1,G2)
axis([-10 10 -10 10]);

%% symbolic computation - movable line sinks
clf
[X,Y] = meshgrid([-3:0.342:3],[-3:0.342:3]);
%[X1,Y1] = meshgrid([-3:1.142:3],[-3:1.142:3]);
disp('made grid')
syms x y x0
fa = @(m,xi,yi)int(sqrt((x-x0+xi)^2 + ((y-(m*x0)-yi)^2)),x0);
f1 = (subs(fa(0.5,0,0),[x0],{0.3}) - subs(fa(0.5,0,0),[x0],{-0.3}));
f2 = (subs(fa(-0.5,0,0),[x0],{0.3}) - subs(fa(-0.5,0,0),[x0],{-0.3}));
f = -f1 + f2;
g = gradient(f, [x,y]);
disp('made calcs')
% plot it!
figure()
hold off
contour3(X,Y,subs(f,[x,y],{X,Y}))
%G1 = subs(g(1),[x,y],{X1,Y1});
%G2 = subs(g(2),[x,y],{X1,Y1});
hold on
%disp('quiver time')
%quiver(X1,Y1,G1,G2)
axis([-3 3 -3 3]);

disp('made plots')
%% Numerical approximation method

