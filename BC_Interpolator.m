% Interpolator for K.
function K_T = BC_Interpolator(K_a, K_b, T_val)

    % Linear interpolation.
    T_a = 300;
    T_b = 600;
    m = (K_b - K_a)/(T_b - T_a);
    
    % Interpolation result.
    K_T = K_a + m*(T_val - T_a);

end