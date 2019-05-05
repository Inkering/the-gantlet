function [gx,gy] = gradGenerator_multiline(xp, yp, gpts, cx, cy)
% generate the gradient for a particular robot position

% generate a smol mesh just for the imediate area surrounding gradient
% A = [1.4,1.25];
% B = [1.85,0.44];
% C = [0.4,1.5];
% D = [0.8,1.64];
% E = [-1,1];
% F = [1,-1];
% goodpoints = [A,B;
%               C,D;
%               E,F];
goodpoints = gpts;
numlines = size(goodpoints, 1);

[px,py]= meshgrid(xp-0.01:0.01:xp+0.01, yp-0.01:0.01:yp+0.01);
[xlim,ylim] = size(px);
V = zeros(xlim, ylim);

% loop through all coords
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
            current = current - integral(lined,0,norm(vec(1)));
        end
        V(i,j) = current + circle(cx, cy);
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