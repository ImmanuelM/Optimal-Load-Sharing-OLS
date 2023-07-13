%path predict

function [Yhat,param] = pathpredict(Y,t)



x = Y(:,1);
y = Y(:,2);
t = t(:);
coeff = 10;
if length(t)< 10
    error('require more data to start prediction (minimum 10)')
end

Vand = [ones(length(x),1) x];   %Vandermonde matrix

param = zeros(1,coeff);

models = zeros(1,coeff);

