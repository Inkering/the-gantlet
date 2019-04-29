%% RANSAC Implementation
clear;
load('scan4.mat');
r_clean = nonzeros(r);
theta_clean = theta;
theta_clean(~r) = [];
[x, y] = pol2cart(deg2rad(theta_clean), r_clean);
p = polyfit(x, y, 1)
yp = polyval(p, x);
figure(1);clf;
plot(x,y, 'o');hold on;
plot(x, yp, 'g-');
axis equal;
title('Linear Regression Fit Line (Scan 4)');
xlabel('x position (meters)');
ylabel('y position (meters)');


coefficients = pca([x y]);
m = coefficients(2,1) / coefficients(1,1)
b = mean(y) - m * mean(x)
pcay = polyval([m b], x);
plot(x, pcay, 'r')

clearvars -except x y

points = [x y];

n = 50;
d = 0.1;

bestInliersSoFar = 0;
bestPoint1SoFar = [0 0];
bestPoint2SoFar = [0 0];
bestTestLineSoFar = [];
bestMatchedPoints = [];

% For each point pair
for i = 1:n
    matchedPoints = [];
    % Randomly select the points
    point1 = points(randi([1, length(points)]),:);
    point2 = points(randi([1, length(points)]),:);
    
    % Find and plot the line between them
    p = polyfit([point1(1) point2(1)], [point1(2) point2(2)], 1);
    testline = polyval(p, x);
    plot(x, testline, 'cyan', 'HandleVisibility', 'off')
    
    % Plot the endpoints in cyan
    plot(point1(1), point1(2), 'cyano', 'HandleVisibility', 'off')
    plot(point2(1), point2(2), 'cyano', 'HandleVisibility', 'off')
    
    % Find the tangent vector
    That = (point2 - point1) ./ vecnorm(point2 - point1);
    % Find the normal vector
    Nhat = ([-That(2) That(1)]);
    
    inliers = 0;
    
    % Test every point with this fit line
    for j = 1:length(points)

        r = points(j,:) - point1;
        
        a = point1 - point2;
        a(3) = 0;
        b = points(j,:) - point2;
        b(3) = 0;
%         dist = norm(cross(a,b)) / norm(a);
        
        dist = dot(r,Nhat)
        
        if abs(dist) <= d
            inliers = inliers + 1;
            matchedPoints(end+1,:) = points(j,:);
        end
    end
    
    if inliers > bestInliersSoFar
        bestMatchedPoints = matchedPoints;
        bestPoint1SoFar = point1;
        bestPoint2SoFar = point2;
        bestTestLineSoFar = testline;
        bestInliersSoFar = inliers;
        disp(inliers)
    end
    
    axis([min(x) max(x) min(y) max(y)]);
    
%     pause(1)
end

plot(x, testline, 'cyan')
plot(x, testline, 'r*')

plot(bestMatchedPoints(:,1), bestMatchedPoints(:,2), 'gs')

legend('Dataset', 'Linear Regression', 'PCA Fit', 'Fit Lines Tested', 'RANSAC Fit Line')














