function  [A, A_dist] = routing_withcomp(V,range,only_source,Computation_level,plots)
antenna_range = range;            %maximum range of antenna.
beams_n = 10;                 %maximum number of beams possible. 


node_locs = V;
nodes_n = length(V);

size(node_locs)
colorMap = jet(30);
%count = 2;
if plots == 1

scatter(node_locs(1,1),node_locs(1,2),150,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5)
% node_locs_new(1,:) = node_locs(1,:);
hold
    for n = 2 : length(node_locs)
        ratio = (1-Computation_level(n)) *0.9;
        
    scatter(node_locs(n,1),node_locs(n,2),150,'MarkerEdgeColor',[0 0 .5],...
                  'MarkerFaceColor',colorMap(floor(ratio*length(colorMap))+1,:),...
                  'LineWidth',1.5)
%               if ratio == 0
%                   node_locs_new(count,:) = node_locs(n,:);
%                   count = count+1;
%               end
    end          
end
% % count
% node_locs = node_locs_new;
% size(node_locs)
% nodes_n = length(node_locs);
% nodes_n
%sum(Computation_level)
Computation_level(1) = 1;
size(Computation_level)
%Cj = diag(Computation_level) * ones(nodes_n);

title('Selection of nodes with basis of mobility and computation'); 
          
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

Adj_1hop = Adj_1hop - eye(nodes_n);

Adjacency = zeros(size(Adj_1hop));
Adjacency (1,:) = Adj_1hop(1,:) .* Computation_level';


for m = 1 : nodes_n
    if id2(m) == 1
        id_f = Adj_1hop(m,:);
        d = id_f & id1;
        loc = find(d==1);
        for k = 1: length(loc)
            if Computation_level(m) == 1
                Adjacency(loc(k),m) = 1;
                Adjacency(m,loc(k)) = 1;
                Adjacency(loc(k),1) = 1;
                Adjacency(1,loc(k)) = 1;
            end
        end

    end

end


%% plotting the connections
A = Adjacency;
A_dist = (A > 0).*distance;
if plots == 1
    if only_source == 1
        for m = 1 : nodes_n
            for n = 1 : nodes_n
                if Adjacency(m,n) ~= 0
                    ratio = min(distance(m,n)/antenna_range,0.9);
                    floor(ratio*length(colorMap))+1;
                    
                    line([node_locs(m,1) node_locs(n,1)] , [node_locs(m,2) node_locs(n,2)],'LineWidth',2,'Color',colorMap(floor(ratio*length(colorMap))+1,:));

                end
            end
        end
    end
end
colormap(jet)
h = colorbar;
h = colorbar('Ticks',[0,1/4,1/2,0.75,1],...
         'TickLabels',{'Good','Good','Good','Average','Poor'},'FontSize',12);
h.Label.String = 'Link Qiality (or) Computational availability';

xlim([node_locs(1,1)-antenna_range-5,node_locs(1,1)+antenna_range+5])
ylim([node_locs(1,2)-antenna_range-5,node_locs(1,2)+antenna_range+5])
grid on
box on
hold
return

