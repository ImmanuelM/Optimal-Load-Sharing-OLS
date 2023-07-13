function  [A, A_dist] = routing(V,range,only_source,Computation_level,plots)
antenna_range = range;            %maximum range of antenna.
beams_n = 10;                 %maximum number of beams possible. 


node_locs = V;
nodes_n = length(V);

size(node_locs)
colorMap = jet(30);
if plots == 1

scatter(node_locs(1,1),node_locs(1,2),150,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5)
hold
    for n = 2 : length(node_locs)
        ratio = (1-Computation_level(n)) *0.9;
        
    scatter(node_locs(n,1),node_locs(n,2),150,'MarkerEdgeColor',[0 0 .5],...
                  'MarkerFaceColor',colorMap(floor(ratio*length(colorMap))+1,:),...
                  'LineWidth',1.5)
    end          
end
title('Selection of nodes with basis of mobility');          
%node_locs = [source_locs;relay_locs;destination_locs];


X_dist = ones( nodes_n)*diag(node_locs(:,1))-(ones(nodes_n)*diag(node_locs(:,1)))';
Y_dist = ones(nodes_n)*diag(node_locs(:,2))-(ones(nodes_n)*diag(node_locs(:,2)))';
distance =( X_dist.^2+Y_dist.^2).^0.5;

Adj_1hop = distance < antenna_range; % All possible connections

id1 = Adj_1hop(1,:);
%% maintaining routes and determining two hop routes
hops = 3;
Adj_2hop = (Adj_1hop^2==1);
id2 = Adj_2hop(1,:);
% Adj_3hop = (Adjacency^3==1);
% id3 = Adj_3hop(1,:);

Adj_1hop = Adj_1hop - eye(nodes_n);

Adjacency = zeros(size(Adj_1hop));
Adjacency (1,:) = Adj_1hop(1,:);

%for n = 1 : nodes_n
    for m = 1 : nodes_n
        if id2(m) == 1
            id_f = Adj_1hop(m,:);
            dist = distance(m,:);
            d = id_f & id1;
            loc = find(d==1);
            
            Adjacency(loc(1,1),m) = 1;
            Adjacency(m,loc(1,1)) = 1;
            Adjacency(loc(1,1),1) = 1;
          %  Adjacency(1,loc(1,1)) = 1;
            %tot_dist
            
        end
            
    end
%end
         
    
    




%Adjacency = (Adj_1hop | Adj_2hop) | Adj_3hop;

%Adjacency = Adjacency.*Adj;
                        



% %distance
% [node_locs2,~] = sort_mat(node_locs(1:end,:)',distance(1,1:end),'ascend');  %sorting nodes based on distance from source node. 
% node_locs(1:end,:) = node_locs2';
% 
% X_dist = ones(nodes_n)*diag(node_locs(:,1))-(ones(nodes_n)*diag(node_locs(:,1)))';
% Y_dist = ones(nodes_n)*diag(node_locs(:,2))-(ones(nodes_n)*diag(node_locs(:,2)))';
% distance =( X_dist.^2+Y_dist.^2).^0.5;

% Adjacency = distance < antenna_range;
% Adjacency = Adjacency + (Adjacency.*(-2*(X_dist<0))) - eye(size(Adjacency));
% Abs_Adj = abs(Adjacency);
% check = sum(Abs_Adj,2)  - beams_n;
% 
% 
% for k = 1 : length(check)
%     if check(k) > 0
%         temp = check(k);
%         for l = 1 : temp
%                 locs = find(abs(Adjacency(k,:)) == 1);
%                 [~,id] =  max(check(abs(Adjacency(k,:)) == 1));
%                 Adjacency(k,locs(id)) = 0;
%                 Adjacency(locs(id),k) = 0;
%         end
%         Abs_Adj = abs(Adjacency);
%         check = sum(Abs_Adj,2)  - beams_n;
%     end
% end
% 
% Adjacency = Abs_Adj;

%% removing interconnection between nodes in the same layer and adding  more connections between successive layers
% spare = 0;
% for m = 1 : nodes_n
%     for n = 1 : nodes_n
%         if Adjacency(m,n) ~= 0
%             
%             if node_layer(m) == node_layer(n)
%                 Adjacency(m,n) = 0;
%                 Adjacency(n,m) = 0;
%                 spare = spare + 1;
%             end
%             
%             for kk = 1 : spare
%                 dist_m = (distance(m,:) < antenna_range) & (node_layer ~= node_layer(m))' & (abs(node_layer - node_layer(m)) == 1)';  %% remove the last condition to allow interconnections between two layers. 
%                 for kk2 = 1 : nodes_n
%                    if (Adjacency(m,kk2) == 0) && (dist_m(kk2) == 1)
%                        if X_dist(m,kk2) > 0
%                            Adjacency(m,kk2) = 1;
%                            Adjacency(kk2,m) = -1;
%                        else
%                            Adjacency(m,kk2) = -1;
%                            Adjacency(kk2,m) = 1;
%                        end
%                        break;
%                    end
%                 end
%                 
%             end
%             
%         end
%     end
% end
% 
% 


%% plotting the connections
A = Adjacency;
A_dist = (A > 0).*distance;
if plots == 1

    %colormap(colorMap);
    %colorbar;
    %
    %layers = 3;
    if only_source == 1
        for m = 1 : nodes_n
            for n = 1 : nodes_n
                if Adjacency(m,n) ~= 0
                    ratio = min(distance(m,n)/antenna_range,0.9);
                    
                    
                    line([node_locs(m,1) node_locs(n,1)] , [node_locs(m,2) node_locs(n,2)],'LineWidth',2,'Color',colorMap(floor(ratio*length(colorMap))+1,:));
        %            line([node_locs(m,1) node_locs(m,1)], [node_locs(m,2) node_locs(m,2)+0.5],'LineWidth',2)

        %             line([node_locs(n,1) node_locs(n,2)], [node_locs(n,2) node_locs(n,2)+0.5],'LineWidth',2)
        %         elseif Adjacency(m,n) < 0
        %             line([node_locs(m,1) node_locs(n,1)] , [node_locs(m,2) node_locs(n,2)],'Color','r','LineWidth',3)
                end
            end
        end
    end
end
colormap(jet)
%h = colorbar;
h = colorbar('Ticks',[0,1/4,1/2,0.75,1],...
         'TickLabels',{'Good','Good','Good','Average','Poor'},'FontSize',12);
h.Label.String = 'Link Qiality (or) Computational availability';


xlim([node_locs(1,1)-antenna_range-5,node_locs(1,1)+antenna_range+5])
ylim([node_locs(1,2)-antenna_range-5,node_locs(1,2)+antenna_range+5])
grid on
box on
hold
return

