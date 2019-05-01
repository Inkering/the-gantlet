
%edit your ranges to display here.  important to not include the actual
%location of your object in this grid of points or it will give you
%infinities

[px,py]=meshgrid(0:0.1:2,0:0.1:2.5);
[xlim,ylim] = size(px);
V = zeros(xlim, ylim);

for i=1:xlim
    for j=1:ylim
        %this is the equation and integral with ranges for a specific object:  you
        %should be able to figure out what this is and edit appropriately to get
        %what you want

        line = @(x0,m,xi,yi) sqrt((px(i,j)-x0-xi).^2 + ((py(i,j)-(m.*x0)-yi).^2));
        round = @(xi,yi) sqrt((px(i,j)-xi).^2 + ((py(i,j)-yi).^2));
        dV = @(x0) line(x0, 1,0,0) +...
                   line(x0, 1,2,0) +...
                   line(x0, -1,0,2) +...
                   line(x0, -1,0,2);
        dV2 = @(x0)line(x0, 0.1,0,0);
        dV3 = @(x0)line(x0, 1,0,0);
        dV4 = @(x0)line(x0, 100,2,1.25);
        V(i,j) = -0.1*integral(dV3,-2,2); %- integral(dV4,-2,2); %+ integral(dV3,0,2.5);% + 0.1*round(1,1.25);
    end
end
figure()
hold off
%contour3(px,py,V)
surf(px,py,V)
[Ex,Ey] = gradient(V);
hold on
axis equal
%quiver(px,py,-Ex,-Ey)