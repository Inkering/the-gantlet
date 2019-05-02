%% RANSAC Implementation
clear;rng(3);
load('oneScanData.mat');
x = data(1,:)';
y = data(2,:)';

size(x)
size(y)


toremove = [];
for i = 1:1:length(x)
    if(x(i) > 0.9)
        if(x(i) < 1.2)
            if(y(i) > 1.7)
                if(y(i) < 1.9)
                    toremove = vertcat(toremove, i);
                end
            end
        end
    end
end

% x(toremove) = [];
% y(toremove) = [];

size(x)
size(y)

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
totalInliers = 100;
    
while(totalInliers > 5)
    x = outliers(:,1);
    y = outliers(:,2);

    [A, B, bestTestLine, outliers, inliers, totalInliers] = RANSAC(x,y,0.05,20);

    lengths = vecnorm(inliers' - [10; 10]);
    [~, ia] = min(lengths);
    [~, ib] = max(lengths);
    end1 = inliers(ia,:);
    end2 = inliers(ib,:);
    line = [end1; end2];
    plot(line(:,1), line(:,2), 'g', 'LineWidth', 5)

end





toc

ylim([-1 3])
axis equal







legend('Dataset', 'RANSAC Fit Line')







function [A, B, bestTestLine, outliers, inliers, totalInliers] = RANSAC(x,y,d,n)
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
totalInliers = length(inliers);
endA = 0;
endB = 0;
bestTestLine = bestTestLineSoFar;
A = bestPoint1SoFar;
B = bestPoint2SoFar;
outliers = bestOutliersSoFar;
end


