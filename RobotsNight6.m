%% Exercise 6: Show Raw Data
load capture1.mat

figure(1);clf
polarscatter(deg2rad(theta_1), r_1, 'o')

figure(2);clf
polarscatter(deg2rad(theta_2), r_2, 'o')

figure(3);clf
polarscatter(deg2rad(theta_3), r_3, 'o')

figure(4);clf
polarscatter(deg2rad(theta_4), r_4, 'o')

%% Exercise 6B
r1_clean = nonzeros(r_1);
theta1_clean = theta_1;
theta1_clean(find(~r_1)) = [];
[x, y] = pol2cart(deg2rad(theta1_clean), r1_clean);

figure(5);clf
plot(x, y, 'o')
xlabel('X position (m)');
ylabel('Y position (m)');
title('Scan 1');
legend('Scan 1');
axis equal

%% Exercise 6C
r2_clean = nonzeros(r_2);
theta2_clean = theta_2;
theta2_clean(find(~r_2)) = [];
[x, y] = pol2cart(deg2rad(theta2_clean), r2_clean);


phi = pi/4;
xn = 0;
yn = 0;

T = [1 0 xn; 0 1 yn; 0 0 1];
R = [cos(phi) -sin(phi) 0; sin(phi) cos(phi) 0; 0 0 1];

points2 = [];

for i = 1:length(r2_clean)
   theta = deg2rad(theta2_clean(i));
   r = r2_clean(i);
   point = [.1 + r .* cos(theta); r .* sin(theta); 1];
   
   points2(:,i) = T * R * point;
end

figure(6);clf
plot(points2(1,:), points2(2,:), 'o')
xlabel('X position (m)');
ylabel('Y position (m)');
title('Scan 2 Global Frame');
legend('Scan 2');
axis equal

%% Exercise 6D
r3_clean = nonzeros(r_3);
theta3_clean = theta_3;
theta3_clean(find(~r_3)) = [];
[x, y] = pol2cart(deg2rad(theta3_clean), r3_clean);


phi = 0;
xn = 1;
yn = 0;

T = [1 0 xn; 0 1 yn; 0 0 1];
R = [cos(phi) -sin(phi) 0; sin(phi) cos(phi) 0; 0 0 1];

points3 = [];

for i = 1:length(r3_clean)
   theta = deg2rad(theta3_clean(i));
   r = r3_clean(i);
   point = [.1 + r .* cos(theta); r .* sin(theta); 1];
   
   points3(:,i) = T * R * point;
end

figure(7);clf
plot(points3(1,:), points3(2,:), 'o')
xlabel('X position (m)');
ylabel('Y position (m)');
title('Scan 3 Global Frame');
legend('Scan 3');
axis equal

%% Exercise 6E
r4_clean = nonzeros(r_4);
theta4_clean = theta_4;
theta4_clean(find(~r_4)) = [];
[x, y] = pol2cart(deg2rad(theta4_clean), r4_clean);


phi = pi/2;
xn = 0;
yn = 0.9;

T = [1 0 xn; 0 1 yn; 0 0 1];
R = [cos(phi) -sin(phi) 0; sin(phi) cos(phi) 0; 0 0 1];

points4 = [];

for i = 1:length(r4_clean)
   theta = deg2rad(theta4_clean(i));
   r = r4_clean(i);
   point = [.1 + r .* cos(theta); r .* sin(theta); 1];
   
   points4(:,i) = T * R * point;
end

figure(8);clf
plot(points4(1,:), points4(2,:), 'o')
xlabel('X position (m)');
ylabel('Y position (m)');
title('Scan 4 Global Frame');
legend('Scan 4');
axis equal

%% Exercise 6: All Scans Combined Into Map

r1_clean = nonzeros(r_1);
theta1_clean = theta_1;
theta1_clean(find(~r_1)) = [];
[x, y] = pol2cart(deg2rad(theta1_clean), r1_clean);


phi = 0;
xn = 0;
yn = 0;

T = [1 0 xn; 0 1 yn; 0 0 1];
R = [cos(phi) -sin(phi) 0; sin(phi) cos(phi) 0; 0 0 1];

points1 = [];

for i = 1:length(r1_clean)
   theta = deg2rad(theta1_clean(i));
   r = r1_clean(i);
   point = [.1 + r .* cos(theta); r .* sin(theta); 1];
   
   points1(:,i) = T * R * point;
end

figure(9);clf; hold on;
plot(points1(1,:), points1(2,:), 'o')
plot(points2(1,:), points2(2,:), 'o')
plot(points3(1,:), points3(2,:), 'o')
plot(points4(1,:), points4(2,:), 'o')
xlabel('X position (m)');
ylabel('Y position (m)');
title('Global Map');
legend('Scan 1', 'Scan 2', 'Scan 3', 'Scan 4');
axis equal

