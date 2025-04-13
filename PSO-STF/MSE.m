function Error = MSE(x, y)

    global NFE;
    if isempty(NFE)
        NFE = 0;
    end
    
    NFE = NFE + 1;

    [~ , n] = size(x);
    
        Error = sum((x - y).^2)/n;

end

