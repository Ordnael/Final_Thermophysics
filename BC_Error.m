% Error calculation function.
function error = BC_Error(T_1, T_2)

    sT = size(T_1,1);
    
    % Extracting the temperatures of first and last node.
    sum_error = 0;
    for iIter = 1:sT
        add_1 = (T_1(iIter,2) - T_2(iIter,2))^2;
        add_2 = (T_1(iIter,end-1) - T_2(iIter,end-1))^2;
        sum_error = sum_error + sqrt(add_1) + sqrt(add_2);
    end

    error = sum_error;
end