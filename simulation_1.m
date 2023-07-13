close all;
clear all;

G = [100: 10000: 10000000000];

C0 = 249.6*10^9;
Cinf = 249.6*10^100;
A = 10.23;
t_1 = 10.3*((G).^1.5)/C0;   %time for single node to compute

%plot(G,t_1,'-.','linewidth',2)

% designing for n nodes in layer 1. 

n = 2 : 2 : 10; %number of nodes in first hop

T = 10*10^6; %maximum throughput in bits per second  %to the slowest node in computational layer 1

T0 = T/(8*1500);  %throughput in packets per second

t_shared = zeros(length(n),length(G));
for ll = 1 : length(n)
    load_shared = G./(n(ll)+1);
    
    communication_time = load_shared/(1500*T0);
    computation_time = 10.3*(load_shared.^1.5)/C0;
    t_shared(ll,:) = communication_time+computation_time;
    
    
end

%hold


%plot(G,t_shared,'linewidth',2)

%communication to cloud server at X hops away
p0 = 0.5;
t_communication = zeros(length(n),length(G));
for ll = 1 : length(n)
    
    communication_time = G/(n(ll)*1500*T0*p0);
    
    t_communication(ll,:) = communication_time;
    
    
end


%plot(G,t_communication, '--', 'linewidth',2)

Y_matrix = [t_1;t_shared;t_communication];

createfigure(G,Y_matrix);