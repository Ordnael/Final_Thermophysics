% Internal node calculation.
function node_T = BC_Node(T, r, dr, prod_t, K_sim, iTime, iNode)

    % Calculate the inside values.
    c1 = (T(iTime,iNode+1) - 2*T(iTime,iNode) + T(iTime,iNode-1))/(dr^2);
    c2 = (T(iTime,iNode+1) - T(iTime,iNode-1))/(r*dr);
    c3 = (T(iTime,iNode+1) - T(iTime,iNode-1))/(dr^2);
    c_val = K_sim(2)*(c1 + c2) + (K_sim(1) + K_sim(3))*c3;
    
    node_T = prod_t*c_val + T(iTime,iNode);

end