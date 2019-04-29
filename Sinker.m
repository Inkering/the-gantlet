%% symbolic computation
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

%% numeric approximation
figure()

[X,Y] = meshgrid([-10:0.142:10],[-10:0.142:10]);
[X1,Y1] = meshgrid([-10:1.142:10],[-10:1.142:10]);

x = X
y = Y