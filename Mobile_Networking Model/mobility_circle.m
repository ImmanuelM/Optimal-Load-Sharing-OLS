%predicting mobvement in a circle
close all
clc;
clear all


t = 0 : .1: 20;

x = 500*(cos(2*pi*0.1*t)+0.000001*randn(size(t)));
y = 200*(sin(2*pi*0.1*t)+0.000001*randn(size(t)));
figure()
subplot(2,2,1)
scatter(x,y);

xlabel('X-coordinate')
ylabel('Y-coordinate')
hold on;


subplot(2,2,2)
scatter(t,x);
xlabel('Time')
ylabel('Y-coordinate')
hold on;


subplot(2,2,3)
scatter(t,y);
xlabel('Time')
ylabel('Y-coordinate')
hold on;

%%

stop = 0;
st_size = 20;
step = 1;

Path = [x(:) , y(:)];
while (stop ==0)
    t_pred = t(step*st_size:(step+1)*st_size);
    [Path_predicted,param1] = pathpredict(Path(1:step*st_size,:),t(1:step*st_size),t_pred);
%     [yhat,param2] = pathpredict(y(1:step*st_size),t(1:step*st_size),t(step*st_size:(step+1)*st_size));
    xhat = Path_predicted(:,1);
    yhat = Path_predicted(:,2);
    subplot(2,2,1)
    scatter(xhat,yhat,'r')
    
    subplot(2,2,2)
    scatter(t_pred,xhat,'r');
    
    subplot(2,2,3)
    scatter(t_pred,yhat,'r');
    step = step+1;
    
end

