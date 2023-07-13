%Simulation_2
clear all;
close all;
clc;

C = [ 100*10^9, 100*10^9, 50000*10^9];
T = [ Inf, 10*10^6/8 , 3*10^6/8];
G = [1000: 10000: 100000000];
%%
n = 3;
phi_1 = C/sum(C);
temp = rand(1,3);
phi_1 = temp/sum(temp);
time_suboptimal = zeros(n,length(G));

%t_shared = zeros(length(n),length(G));
for ll = 1 : n
    load_shared = G*phi_1(ll);
    
    communication_time = load_shared/(T(ll));
    computation_time = 10.3*(load_shared.^1.5)/C(ll);
    time_suboptimal(ll,:) = communication_time+computation_time;
end

time_sub = max(time_suboptimal);
%%
time_optimal = zeros(size(G));
for kk = 1 : length(G)
    clc;
    kk/length(G)
    iter = 1;
    cost_best = 100000000;
    while iter  < 10
    [phi_temp,cost] = Optimization_v1(C,T,G(kk),10.3);
    if cost < cost_best
        phi_opt = phi_temp;
        cost_best = cost;
    end
    iter = iter+1;
    end
    comp_time =  10.3*((G(kk).*phi_opt).^1.5)./C;
    comm_time = (G(kk).*phi_opt)./T;
    total = comp_time+comm_time;
    time_optimal(kk) = max(total);
end
%%
time_cloud = 10.3*(G.^1.5)/C(3) + G/T(3);
%%



plot(G,time_sub)
hold
plot(G,time_cloud,'r')
plot(G,time_optimal,'g')
hold