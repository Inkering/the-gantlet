%% RANSAC Implementation
clear;rng(3);
load('allRoomDataCleaned.mat');
x = data(1,:)';
y = data(2,:)';

size(x)

points = [x y];

xkeep = find(x < 0.9 | x > 1.2);
ykeep = find(y < 1.65 | y > 1.9);
tokeep = intersect(xkeep, ykeep);

points = points(tokeep,:);
x = points(:,1);
y = points(:,2);

size(x)


figure(1);clf;
plot(x,y, '.');hold on;
axis equal;
title('RANSAC Room Map');
xlabel('x position (meters)');
ylabel('y position (meters)');

clearvars -except x y
tic
[A, B, bestTestLine, outliers, inliers] = RANSAC(x,y,0.05,100);

% plot(inliers(:,1), inliers(:,2), 'ks')

p = polyfit([A(1) B(1)], [A(2) B(2)], 1);
% testline = polyval(p, x);

lengths = vecnorm(inliers' - [10; 10]);
[~, ia] = min(lengths);
[~, ib] = max(lengths);
end1 = inliers(ia,:);
end2 = inliers(ib,:);
line = [end1; end2];
plot(line(:,1), line(:,2), 'g', 'LineWidth', 5)


% plot(x, testline, 'ro')

for i = 1:5
    x = outliers(:,1);
    y = outliers(:,2);

    [A, B, bestTestLine, outliers, inliers] = RANSAC(x,y,0.1,20);

    lengths = vecnorm(inliers' - [10; 10]);
    [~, ia] = min(lengths);
    [~, ib] = max(lengths);
    end1 = inliers(ia,:);
    end2 = inliers(ib,:);
    line = [end1; end2];
    plot(line(:,1), line(:,2), 'g', 'LineWidth', 5)

end




x = outliers(:,1);
y = outliers(:,2);

[A, B, bestTestLine, outliers, inliers] = RANSAC(x,y,0.1,20);

lengths = vecnorm(inliers' - [10; 10]);
[~, ia] = min(lengths);
[~, ib] = max(lengths);
end1 = inliers(ia,:);
end2 = inliers(ib,:);
line = [end1; end2];
plot(line(:,1), line(:,2), 'r', 'LineWidth', 5)
plot(inliers(:,1), inliers(:,2), 'ks')





toc

ylim([-1 3])
axis equal







legend('Dataset', 'RANSAC Fit Line')







function [A, B, bestTestLine, outliers, inliers] = RANSAC(x,y,d,n)
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
    inlierPoints = [];
    % Test every point with this fit line
    for j = 1:length(points)
        r = horzcat(points(j,:) - A, 0);
        dist = dot(r,Nhat);
        if abs(dist) <= d
            inliers = inliers + 1;
            inlierPoints = vertcat(inlierPoints, points(j,:));
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
        bestInlierPointsSoFar = inlierPoints;
    end
end
inliers = rmoutliers(bestInlierPointsSoFar, 'median');
endA = 0;
endB = 0;
bestTestLine = bestTestLineSoFar;
A = bestPoint1SoFar;
B = bestPoint2SoFar;
outliers = bestOutliersSoFar;
end


