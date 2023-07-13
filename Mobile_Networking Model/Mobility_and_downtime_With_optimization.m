

%Mobility and Downtime Simulation
clear all;
clc;
%close all;
rng(2)



% a = gca();
% a.FontSize = 12;
% a.Title


nodes_n = 50;
dispersal = 12;
V = dispersal*randn(nodes_n,2);

fixed = .2;

fixed_nodes = ceil(fixed*(nodes_n-1))+1;

C_max = 100000;

%C = randi(2,[1,nodes_n])-1;
C = rand(1,nodes_n) > 0.1;
C = C(:);
C_prob = C*0.01 + (1-C) * 0.1;
% C = randi(2,[1,nodes_n])-1;
C = rand(1,nodes_n) > 0.1;
C = C(:);
mobile = nodes_n - (fixed_nodes);
source_mobility = 0;
if source_mobility == 1
    bias = randn(mobile+1,2);
else
    bias = randn(mobile,2);
end

fs = 10;
speed = 1/fs*diag(1*ones(mobile,1));
T = 10;
t = 0 : 1/fs : T;  %time axis
V_time = zeros(size(V,1),size(V,2),length(t));
V_time(:,:,1) = V(:,:);
Adj = zeros(nodes_n,nodes_n,length(t));

Adj_dist = zeros(nodes_n,nodes_n,length(t));
%vid = VideoWriter('Mobility_model.avi');
%vid.FrameRate = 15; 
%open(vid)
source_speed = rand();
Adj_old = zeros(nodes_n,nodes_n);
C_time = zeros(nodes_n,length(t));
C_time(:,1) = C;
for n = 2 : length(t)
    temp = rand(nodes_n,1);
    change = temp < C_prob;
    C_time(:,n) = xor(C_time(:,n-1),change);
    
    
    if source_mobility == 0
        V_time(1:fixed_nodes,:,n) = V(1:fixed_nodes,:);
%         motion_vec = 0.5*speed*randn(seeds_no,2)+2*speed*bias;
%         size(speed)
%        size(diag(rand(mobile,1)))
%        size(bias)
       size(V_time(fixed_nodes+1:end,:,n-1))
        V_time(fixed_nodes+1:end,:,n) = V_time(fixed_nodes+1:end,:,n-1) + speed*bias+ speed/10*randn(mobile,2);
    else
        V_time(1,:,n) = V_time(1,:,n-1) + (source_speed*rand()*bias(1,:)+ source_speed/10*randn(1,2));
        V_time(2:fixed_nodes,:,n) = V(2:fixed_nodes,:);
        
        V_time(fixed_nodes+1:end,:,n) = V_time(fixed_nodes+1:end,:,n-1) + (speed*diag(rand(mobile,1))*bias(2:end,:)+ speed/10*randn(mobile,2));
    end
    
    V_now = zeros(nodes_n,2);
    V_now(:,:) = V_time(:,:,n);
    dist_origin = ((V_now(fixed_nodes+1:end,1)).^2+(V_now(fixed_nodes+1:end,2)).^2).^0.5;
   % size(dist_origin)
   % size(bias)
    out_box = dist_origin > 20;
    in_box = dist_origin <= 20;
    bias = diag(in_box)*bias - diag(out_box)*bias;
    
    [A1, A2 ] = routing_withcomp(V_now,10,1,C_time(:,n),0);
    Adj(:,:,n) = A1(:,:);
    Adj_dist(:,:,n) = A2(:,:);
%     fr = getframe(gcf);
%     writeVideo(vid,fr);
%   %  pause(0.1)
%     
    
end
%close (vid)

