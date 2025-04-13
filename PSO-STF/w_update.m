function e = w_update(weights, g, n, concepts)

[rows, ~] = size(weights);
weights_old = weights;

weights_new = zeros(rows,rows);
for j = 1:rows
        for i = 1:rows    
           if weights_old(j,i)~=0    
                weights_new(j,i) = g * weights_old(j,i) + n*concepts(j) * (concepts(j) - sign(weights(j,i)) * (weights_old(j,i) * concepts(i)));
           else
               weights_new(j,i) = 0;
          end                                       
        end
end
     e = weights_new;           
end