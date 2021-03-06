
%edit your ranges to display here.  important to not include the actual
%location of your object in this grid of points or it will give you
%infinities

[px,py]=meshgrid(0:0.1:2,0:0.1:2.5); %what if instead of starting at 0 you started at robot pos??
[xlim,ylim] = size(px);
V = zeros(xlim, ylim);

for i=1:xlim
    for j=1:ylim
        %this is the equation and integral with ranges for a specific object:  you
        %should be able to figure out what this is and edit appropriately to get
        %what you want

        line = @(x0,m,xi,yi) log(sqrt(( px(i,j)-x0-xi).^2 + ((py(i,j)-(m.*x0)-yi).^2)));
        circle = @(xi,yi) log(sqrt((px(i,j)-xi).^2 + ((py(i,j)-yi).^2)));
        dV4 = @(x0)line(x0, -1,1.5,1);
        dV5 = @(x0)line(x0, 1,0.5,1.5);
        dV3 = @(x0)line(x0, 0.01,0,0);
        dV6 = @(x0)line(x0, 0.01,0,2.5);
        dV7 = @(x0)line(x0, -1,0,0);
        dV8 = @(x0)line(x0, 1000,2,0);
        V(i,j) = integral(dV5,0.2,-0.2) + 2*integral(dV4,0.2,-0.2) + integral(dV3,4,-4) + integral(dV6,4,-4) + integral(dV7,4,-4)./3 + 6*integral(dV8,4,-4) + circle(1.75,2.25);
    end
end
figure(1), clf
hold off
contour(px,py,V)
%surf(px,py,V)
[Ex,Ey] = gradient(V);
hold on
axis equal
colorbar
quiver(px,py,-3*Ex,-3*Ey)