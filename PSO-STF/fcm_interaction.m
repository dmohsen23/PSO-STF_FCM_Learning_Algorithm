function [vec] = fcm_interaction(concepts, weights)

[~, columns] = size(concepts);
sum_temp = 0;
temp_counter = 1;

diff = ones(1, columns);
ak = zeros(1, columns);
while (~all(diff < 0.00001))    
    
    for i = 1:columns
            for j = 1:columns
                if(i ~= j)
                    sum_temp = sum_temp + weights(j,i) * (concepts(j));
                end
            end
            
         ak(i) = concepts(i) + sum_temp;
         ak(i) = sigmf(ak(i),[1,0]);      
         sum_temp = 0;   
         
    end
    
    diff = abs(concepts-ak);
    concepts = ak;
    temp_counter = temp_counter+1;  
    
end
    vec = ak;
end