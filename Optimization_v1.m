%computation of optimal solution for load distribution






function [phi,cost] = Optimization_v1(C,T,G,A)
threshold = 0.00001;
threshold2 = G/(10000*max(C));
max_iterations = 1000;
max_iterations2 = 50;
n = length(C);
phi = rand(1,n);
phi = phi/sum(phi);
cost_old = 10000000;
cost_new = 100;
iter2 = 0;
best_cost = 1000000;

while ((abs(cost_new - cost_old)>threshold2) && (iter2 < max_iterations2))
    iter2 = iter2+1;
    cost_old = cost_new;
    for ll = 1 : n
        iter = 0;
        increment = 1/10;
        inc_direction = +1;
        Comp = A*(phi*G).^1.5./C;
        Comm = (phi*G)./T;
        temp = Comp+Comm;
        cost1 = (temp(1:end-1)-temp(2:end)).^2;
        sqrd_err1 = sum(cost1);
        sqrd_err2 = NaN;
        while( (abs(increment) > threshold) && (iter < max_iterations))
            iter = iter+1;
            temp = phi(1:n~=ll)-(increment*cost1)/sum(cost1);
            %temp2 = phi(ll) + increment;
            if (((phi(ll) + increment) > 1)||( phi(ll) + increment) < 0)
                break;
            end
            if ((max(temp) > 1)|| min(temp) < 0)
                break;
            end
            phi(ll) = phi(ll) + increment;

            phi(1:n~=ll) = phi(1:n~=ll)-(increment*cost1)/sum(cost1);
            Comp = A*((phi*G).^1.5)./C;
            Comm = (phi*G)./T;
            temp = Comp+Comm;
            cost2 = (temp(1:end-1)-temp(2:end)).^2;
            sqrd_err2 = sum(cost2);
            temp = inc_direction;
           % increment = inc_direction*(sqrd_err1-sqrd_err2)/max(sqrd_err1,sqrd_err2); 
            inc_direction = sign(inc_direction*(sqrd_err1-sqrd_err2)/max(sqrd_err1,sqrd_err2)); 
            cost1 = cost2;
            sqrd_err1 = sqrd_err2;
            if inc_direction ~= temp
                increment = inc_direction*increment /2;
            end
            %increment = increment*inc_direction;
        end
    end
    if (isnan(sqrd_err2) == 1)
        sqrd_err2 = 100000;
    end
    cost_new = sqrd_err2;
    
    if cost_new < best_cost
        phi_best = phi;
        best_cost = cost_new;
    end
end


cost = best_cost;
phi = phi_best;