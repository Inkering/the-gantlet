r = [1;1.5];

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
        V(i,j) = 2*integral(dV5,0.2,-0.2) + 2*integral(dV4,0.2,-0.2) + -2*integral(dV3,0.2,-0.2) + 0.5*integral(dV2,1,-1);
    end
end

contour3(px,py,V)
[Ex,Ey] = gradient(V);
hold on
axis equal
colorbar
quiver(px,py,Ex,Ey)

% do the descending
xp = round(r(1),2);
yp = round(r(2),2);
[gx, gy] = gradGenerator(xp,yp)
grad = 30.*[-gx;-gy]
quiver(xp,yp, grad(1),grad(2))

r = [1.5;2];
xp = round(r(1),2);
yp = round(r(2),2);
[gx, gy] = gradGenerator(xp,yp)
grad = 30.*[-gx;-gy]
quiver(xp,yp, grad(1),grad(2))

