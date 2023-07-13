close all
clear all

radius = 1;
x = radius*randn(1,2); %initializing starting position

bias = randn(1,2);
bias = bias./norm(bias);

t = 0: 0.1 : 20;
Ts = 0.1;
path_a = zeros(length(t),2);

vel = 40;  % average velocity in meters / sec
path_a(1,:) = x;
path_b(1,:) = x;
for n = 2 : length(t)
    path_a(n,:) = path_a(n-1,:) + vel*Ts*bias - 2*t(n)^2*vel*Ts + 3*t(n)^3*vel*Ts - 3*t(n)^4*vel*Ts;
    path_b(n,:) = path_a(n,:) + randn(1,2)*3000000;
%    path_a(n,:) = path_a(n-1,:) + (t(n)^3)*vel*Ts*.5*randn(1,2) + 2*(t(n)^2)*vel*Ts*randn(1,2)+  vel*Ts*randn(1,2);
%    path_b(n,:) = path_b(n-1,:) + (t(n)^3)*vel*Ts*0.25 + 2*(t(n)^2)*vel*Ts*randn(1,2)+  vel*Ts*randn(1,2);
end


plot3(t,path_b(:,1),path_b(:,2))
xlabel('time')
ylabel('X')
zlabel('Y')
hold
%plot3(t,path_b(:,1),path_b(:,2),'g')
%%
t_predict = 1: 0.001: 20;

%t_predict = t;
[yhat,param] = pathpredict(path_b,t,t_predict);

plot3(t_predict,yhat(:,1),yhat(:,2),'r')
grid on