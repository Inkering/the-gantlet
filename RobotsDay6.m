%% RANSAC Implementation
clear;
load('allRoomDataCleaned.mat');
x = data(1,:)';
y = data(2,:)';
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

n = 100;
d = 0.05;

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
    
%     plot(x, testline, 'cyan', 'HandleVisibility', 'off')
    
    % Plot the endpoints in cyan
    plot(point1(1), point1(2), 'cyano', 'HandleVisibility', 'off')
    plot(point2(1), point2(2), 'cyano', 'HandleVisibility', 'off')
    
    % Find the tangent vector
    That = (point2 - point1) ./ vecnorm(point2 - point1);
    % Find the normal vector
    Nhat = ([-That(2) That(1)]);
    
    A = point1;
    B = point2;
    
    That = [B(1) - A(1);B(2) - A(2);0]./vecnorm([B(1) - A(1);B(2) - A(2);0]);
    Khat = [0;0;1];
    Nhat = cross(That,Khat);
    
    inliers = 0;
    
    % Test every point with this fit line
    for j = 1:length(points)

        r = points(j,:) - point1;
        r(3) = 0;
        
        a = point1 - point2;
        a(3) = 0;
        b = points(j,:) - point2;
        b(3) = 0;
%         dist = norm(cross(a,b)) / norm(a);
        
        dist = dot(r,Nhat);
        
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
plot(x, bestTestLineSoFar, 'r*')

plot(bestMatchedPoints(:,1), bestMatchedPoints(:,2), 'gs')

legend('Dataset', 'Linear Regression', 'PCA Fit', 'Fit Lines Tested', 'RANSAC Fit Line')