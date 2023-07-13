%path predict

function [Y_predict,param] = pathpredict(Y,t,t_predict)

x = Y(:,1);
y = Y(:,2);
t = t(:);
coeff = min(10,length(t)-1);
if length(t)< 10
    error('require more data to start prediction (minimum 10)')
end

errorx = zeros(1,coeff);
errory = zeros(1,coeff);
paramx = zeros(coeff,coeff);
paramy = zeros(coeff,coeff);
Vand = [];%ones(length(t),1);
count = 0;

for n = 1 : coeff
      Vand = [Vand t.^(n-1)];   %Vandermonde matrix
      paramx(1:n,n) = pinv(Vand)*x;
      paramy(1:n,n) = pinv(Vand)*y;
%       size(Vand)
%       size(paramx(1:n,n))
%       size(Vand*paramx(1:n,n))
%       size(x)
      errorx(n) = sum((Vand*(paramx(1:n,n))-x).^2);
      errory(n) = sum((Vand*(paramy(1:n,n))-y).^2);
      
end

ratiox = errorx(1:end-1)./errorx(2:end);
ratioy = errory(1:end-1)./errory(2:end);

[~,nx] = max(ratiox);
[~,ny] = max(ratioy);
nx = nx+1;
ny = ny+1;
xcoeff = paramx(1:nx,nx);
ycoeff = paramy(1:ny,ny);
% param = [xcoeff ycoeff]';
param = 1;

t_predict = t_predict(:);
Xhat = zeros(length(t_predict),1);

for n = 1 :length(xcoeff)
    
    Xhat = Xhat + xcoeff(n)*(t_predict.^(n-1));
end

Yhat = zeros(length(t_predict),1);

for n = 1 :length(ycoeff)
    
    Yhat = Yhat + ycoeff(n)*(t_predict.^(n-1));
end


Y_predict = [Xhat Yhat];
