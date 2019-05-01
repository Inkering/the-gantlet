%% RANSAC Implementation
clear;rng(1);
load('allRoomDataCleaned.mat');
x = data(1,:)';
y = data(2,:)';
figure(1);clf;
plot(x,y, 'o');hold on;
axis equal;
title('Linear Regression Fit Line (Scan 4)');
xlabel('x position (meters)');
ylabel('y position (meters)');

clearvars -except x y
tic
[A, B, bestTestLine, outliers] = RANSAC(x,y,0.05,100);
p = polyfit([A(1) B(1)], [A(2) B(2)], 1);
testline = polyval(p, x);
plot(x, testline, 'r*')

for i = 1:6
    x = outliers(:,1)
    y = outliers(:,2)

    [A, B, bestTestLine, outliers, endA, endB] = RANSAC(x,y,0.1,20);
    p = polyfit([A(1) B(1)], [A(2) B(2)], 1);
    testline = polyval(p, x);
    plot(x, testline, 'r*')
end
toc

ylim([-1 3])
axis equal







legend('Dataset', 'RANSAC Fit Line')







function [A, B, bestTestLine, outliers, endA, endB] = RANSAC(x,y,d,n)
points = [x y];

bestInliersSoFar = 0;
bestTestLineSoFar = [];
bestInlierPointsSoFar = [];

% For each point pair
for i = 1:n
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
    outliers = [];
    % Test every point with this fit line
    for j = 1:length(points)
        r = horzcat(points(j,:) - A, 0);
        dist = dot(r,Nhat);
        if abs(dist) <= d
            inliers = inliers + 1;
            
        else
            outliers = vertcat(outliers, points(j,:));
        end
    end
    
    if inliers > bestInliersSoFar
        bestPoint1SoFar = A;
        bestPoint2SoFar = B;
        bestTestLineSoFar = testline;
        bestInliersSoFar = inliers;
        bestOutliersSoFar = outliers;
    end
end
sort(bestInliersSoFar)
endA = 0;
endB = 0;
bestTestLine = bestTestLineSoFar;
A = bestPoint1SoFar;
B = bestPoint2SoFar;
outliers = bestOutliersSoFar;
end


