function Cost = Bargain(x, y)

    global NFE;
    if isempty(NFE)
        NFE = 0;
    end
    
    NFE = NFE + 1;

    aw_1 = sum(x(4,:)*y(4)) + sum(x(8,:)*y(8)) + sum(x(10,:)*y(10));
    
    aw_4 = sum(x(5,:)*y(5)) * sum(x(8,:)*y(8)) + sum(x(10,:)*y(10));
    
    aw_6 = sum(x(5,:)*y(5)) + sum(x(8,:)*y(8));

    aw_12 = sum(x(10,:)*y(10)) + sum(x(11,:)*y(11)) + sum(x(13,:)*y(13)) + ...
        sum(x(14,:)*y(14));
    
    aw_14 = sum(x(9,:)*y(9)) + sum(x(10,:)*y(10)) + sum(x(13,:)*y(13));

    aw_16 = sum(x(12,:)*y(12)) + sum(x(13,:)*y(13)) + sum(x(14,:)*y(14));
    
    z1 = abs(aw_1) * abs(aw_4) * abs(aw_6) * abs(aw_12)  * abs(aw_14) * abs(aw_16);
        
    Cost = 1-z1;
      
end