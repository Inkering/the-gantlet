function [gx,gy] = gradGenerator(xp, yp)
% generate the gradient for a particular robot position

% generate a smol mesh just for the imediate area surrounding gradient
[px,py]= meshgrid(xp-0.01:0.01:xp+0.01, yp-0.01:0.01:yp+0.01);
[xlim,ylim] = size(px);
V = zeros(xlim, ylim);

% loop through all coords
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
          V(i,j) = integral(dV5,0.2,-0.2) + 2*integral(dV4,0.2,-0.2) + integral(dV3,4,-4) + integral(dV6,4,-4) + integral(dV7,4,-4)./3 + 6*integral(dV8,4,-4) + circle(1.75,2.25);
    end
end

% plotting options
% figure()
% hold off
% contour(px,py,V)
%surf(px,py,V)

% get gradient
[Ex,Ey] = gradient(V);
% hold on
% axis equal
% colorbar
% quiver(px,py,-Ex,-Ey)


gx = Ex(1,1);
gy = Ey(1,1);
end