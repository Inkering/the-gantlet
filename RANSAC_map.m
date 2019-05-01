%% RANSAC Implementation
clear;
load('allRoomDataCleaned.mat');
x = data(1,:)';
y = data(2,:)';
p = polyfit(x, y, 1);
yp = polyval(p, x);
figure(1);clf;
plot(x,y, 'o');hold on;
plot(x, yp, 'g-');
axis equal;
title('Linear Regression Fit Line (Scan 4)');
xlabel('x position (meters)');
ylabel('y position (meters)');


coefficients = pca([x y]);
m = coefficients(2,1) / coefficients(1,1);
b = mean(y) - m * mean(x);
pcay = polyval([m b], x);
plot(x, pcay, 'r')

clearvars -except x y

[bestTestLine] = RANSAC(x,y,0.05,100);

plot(x, bestTestLine, 'r*')

legend('Dataset', 'Linear Regression', 'PCA Fit', 'RANSAC Fit Line')







function [bestTestLine] = RANSAC(x,y,d,n)
points = [x y];

bestInliersSoFar = 0;
bestTestLineSoFar = [];

% For each point pair
for i = 1:n
    matchedPoints = [];
    % Randomly select the points
    A = points(randi([1, length(points)]),:);
    B = points(randi([1, length(points)]),:);
    
    % Find and plot the line between them
    p = polyfit([A(1) B(1)], [A(2) B(2)], 1);
    testline = polyval(p, x);
    
    That = [B(1) - A(1);B(2) - A(2);0]./vecnorm([B(1) - A(1);B(2) - A(2);0]);
    Khat = [0;0;1];
    Nhat = cross(That,Khat);
    
    inliers = 0;
    
    % Test every point with this fit line
    for j = 1:length(points)

        r = points(j,:) - A;
        r(3) = 0;
        
        a = A - B;
        a(3) = 0;
        b = points(j,:) - B;
        b(3) = 0;
%         dist = norm(cross(a,b)) / norm(a);
        
        dist = dot(r,Nhat);
        
        if abs(dist) <= d
            inliers = inliers + 1;
            matchedPoints(end+1,:) = points(j,:);
        end
    end
    
    if inliers > bestInliersSoFar
        bestPoint1SoFar = A;
        bestPoint2SoFar = B;
        bestTestLineSoFar = testline;
        bestInliersSoFar = inliers;
        disp(inliers)
    end
    
    axis([min(x) max(x) min(y) max(y)]);
    
%     pause(1)
end
bestTestLine = bestTestLineSoFar
end





