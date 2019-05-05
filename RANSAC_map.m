%% RANSAC Implementation
clear;rng(3);
load('allRoomDataCleaned.mat');
x = data(1,:)' + 0.04;
y = data(2,:)' + 0.29;

toremove = [];
for i = 1:1:length(x)
    if(data(1,i)>0.9 && data(1,i)<1.2 && data(2,i)>1.7 && data(2,i)<1.9)
        toremove=vertcat(toremove,i);
    end
end
x(toremove) = [];
y(toremove) = [];


figure(1);clf;
plot(x,y, '.');hold on;
axis equal;
ylim([-1 3]);

clearvars -except x y

minInliers = 5;

tic
inliers = ones(minInliers,1);
while(length(inliers) >= minInliers)
    [line, outliers, inliers] = RANSAC([x y],5/100,20);
    plot(line(:,1), line(:,2), 'g', 'LineWidth', 5)

    x = outliers(:,1);
    y = outliers(:,2);
    
end
toc
axis equal
legend('Dataset', 'RANSAC Fit Line');

title('RANSAC Room Map');
xlabel('x position (meters)');
ylabel('y position (meters)');






function [line, outliers, inliers] = RANSAC(data,maxDist,trials)
points = data;
bestInliers = [];
Khat = [0;0;1];

% For each point pair
for i = 1:trials
    % Randomly select the points
    A = points(randi([1, length(points)]),:);
    B = points(randi([1, length(points)]),:);
    That = [B(1) - A(1);B(2) - A(2);0]./vecnorm([B(1) - A(1);B(2) - A(2);0]);
    Nhat = cross(That,Khat);
    
    outliers = [];
    inliers = [];
    % Test every point with this fit line
    for j = 1:length(points)
        r = horzcat(points(j,:) - A, 0);
        dist = dot(r,Nhat);
        if abs(dist) <= maxDist
            inliers = vertcat(inliers, points(j,:));
        else
            outliers = vertcat(outliers, points(j,:));
        end
    end
    
    if length(inliers) > length(bestInliers)
        bestOutliers = outliers;
        bestInliers = inliers;
    end
end
inliers = rmoutliers(bestInliers, 'median');
outliers = bestOutliers;
maxIn = max(max(inliers));
lengths = vecnorm(inliers' - [maxIn; maxIn]);
[~, A] = min(lengths);
[~, B] = max(lengths);
A = inliers(A,:);
B = inliers(B,:);
line = [A; B];

end


