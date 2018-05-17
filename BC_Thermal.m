% Thermal calculation.
function T_end = BC_Thermal(K_a, K_b, T, r, dr, dt, rhoCp, mat_Conv)

    % Size of the matrix.
    sr = size(T,2);
    st = size(T,1);
    
    % Calculation of virtual nodes for base time step.
    K_l = BC_interpolator(K_a, K_b, T(1,2));
    prod_l = 2*dr*mat_Conv(1,1)/K_l;
    K_r = BC_interpolator(K_a, K_b, T(1,sr-1));
    prod_r = 2*dr*mat_Conv(2,1)/K_r;
    T(1,1) = prod_l*(mat_Conv(1,2) - T(1,2)) + T(1,3);
    T(1,sr) = -prod_r*(mat_Conv(2,2) - T(1,sr-2)) + T(1,sr-3);
    
    % Loop to time steps.
    for iTime = 1:st-1
        
        % First the inner values are calculated.
        for iNode = 2:sr-1
            prod_t = dt/rhoCp;
            K_sim = zeros(1,3);
            K_sim(1,1) = BC_interpolator(K_a, K_b, T(iTime, iNode-1));
            K_sim(1,2) = BC_interpolator(K_a, K_b, T(iTime, iNode));
            K_sim(1,3) = BC_interpolator(K_a, K_b, T(iTime, iNode+1));
            T(iTime+1,iNode) = BC_Node(T, r, dr, prod_t, K_sim, iTime, iNode);
        end
        % Then the outer virtual nodes.
        t_new = iTime + 1;
        K_l = BC_interpolator(K_a, K_b, T(t_new,2));
        prod_l = 2*dr*mat_Conv(1,1)/K_l;
        K_r = BC_interpolator(K_a, K_b, T(t_new,sr-1));
        prod_r = 2*dr*mat_Conv(2,1)/K_r;
        
        T(t_new,1) = prod_l*(mat_Conv(1,2) - T(t_new,2)) + T(t_new,3);
        T(t_new,sr) = -prod_r*(mat_Conv(2,2) - T(t_new,sr-2)) + T(t_new,sr-3);
    end

    T_end = T;

end