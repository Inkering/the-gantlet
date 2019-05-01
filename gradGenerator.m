function output = gradGenerator(xp, yp)
% generate the gradient for a particular robot position

% generate a smol mesh just for the imediate area surrounding gradient
[px,py]= meshgrid(xp-0.01:0.01:xp+0.01, yp-0.01:0.01:yp+0.01);
[xlim,ylim] = size(px);
V = zeros(xlim, ylim);

% loop through all coords
for i=1:xlim
    for j=1:ylim
        % define equation of a line as function
        line = @(x0,m,xi,yi) log(sqrt((px(i,j)-x0-xi).^2 + ((py(i,j)-(m.*x0)-yi).^2)));
        
        % define equation of a circle
        round = @(xi,yi) log(sqrt((px(i,j)-xi).^2 + ((py(i,j)-yi).^2)));
        
        % define potentials for some lines
        dV2 = @(x0)line(x0, 0.01,1,0);
        dV3 = @(x0)line(x0, 1,1.75,2.25);
        dV4 = @(x0)line(x0, -1,1.5,1);
        dV5 = @(x0)line(x0, 1,0.5,1.5);
        
        % build potential at that point
        V(i,j) = 2*integral(dV5,0.2,-0.2) + 2*integral(dV4,0.2,-0.2) + -2*integral(dV3,0.2,-0.2) + 0.5*integral(dV2,1,-1);
    end
end

% plotting options
figure()
hold off
contour3(px,py,V)
%surf(px,py,V)

% get gradient
[Ex,Ey] = gradient(V);
hold on
axis equal
colorbar
quiver(px,py,-Ex,-Ey)

output = [Ex(1,1),Ey(1,1)];
end