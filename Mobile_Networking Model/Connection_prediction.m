%predicting routes


function time = Connection_prediction(Y1,Y2,t,range,tmax)
    Ts = t(2) - t(1);
    t_predict = t(end):Ts:t(end)+tmax; 
    if size(Y1,2) ~= 2
        Y1 = Y1';
    end
    if size(Y2,2) ~= 2
        Y2 = Y2';
    end
    
   [path1,~] = pathpredict(Y1,t,t_predict);
   [path2,~] = pathpredict(Y2,t,t_predict);
    
   Dist = sqrt(sum(((path1 - path2).^2),2));
   range = Dist>range;
   [~,id] = max(Dist > range);
   time = t_predict(id)-t(end);
   
end