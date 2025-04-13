%% Preliminaries

init;
FCM.NHL.str = fprintf('NHL algorithm\n\n');
format short

%% Main NHL Loop

FCM.NHL.sum_temp = 0;
FCM.NHL.function1_old = 10;

cnt = 0; 
k = 0;

FCM.NHL.ak = zeros(1, FCM.concepts.columns);
while (k ~= 1)
    
    for i = 1:FCM.concepts.columns
        for j = 1:FCM.concepts.columns
            if(i ~= j)
                FCM.NHL.sum_temp = FCM.NHL.sum_temp + FCM.weights.matrix(j,i) * (FCM.concepts.matrix(j));
            end
        end
        
    FCM.NHL.ak(i) = FCM.concepts.matrix(i) + FCM.NHL.sum_temp;
    FCM.NHL.ak(i) = sigmf(FCM.NHL.ak(i),[1,0]);      
    FCM.NHL.sum_temp = 0;   
    end
    
    % Waights updating
    FCM.weights.matrix = w_update(FCM.weights.matrix, FCM.NHL.g, FCM.NHL.n, FCM.concepts.matrix);
    
    % Second Termination Condition: Minimizing the variation of the two subsequent values
    FCM.NHL.function2.DOC1 = abs(FCM.NHL.ak(1) - FCM.concepts.matrix(1));
    FCM.NHL.function2.DOC2 = abs(FCM.NHL.ak(2) - FCM.concepts.matrix(2));
    
    cnt = cnt+1     %#ok
    disp(FCM.weights.matrix);
    
    if(FCM.NHL.function2.DOC1 < FCM.NHL.e && FCM.NHL.function2.DOC2 < FCM.NHL.e)
        k = 1;
        break;
    end
    
    FCM.NHL.function1 = sqrt((FCM.NHL.ak(1) - FCM.NHL.DOC1.t1)^2 + (FCM.NHL.ak(2) - FCM.NHL.DOC2.t2)^2);
    
    % First Termination Condition: Minimizing Euclidean distance of DOC
    if FCM.NHL.function1 >= FCM.NHL.function1_old
        k = 1;
        break;
    end  
    
    FCM.NHL.function1_old = FCM.NHL.function1;
    FCM.concepts.matrix = FCM.NHL.ak;    
    
end

FCM.NHL.Final_Concepts = fcm_interaction(FCM.concepts.matrix, FCM.weights.matrix);
disp(FCM.NHL.Final_Concepts);