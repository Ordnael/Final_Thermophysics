% Principal script.
clear; close all; clc;
tnow = datestr(now,30);

% Time parameters.
t_max = 1;
steps = 1000;

% Element parameters.
radius = 0.1;
nodes = 20;
K_a_t = 13; % At 300 K.
K_b_t = 18; % At 600 K.
rhoCp = 7800*30;

% Radius vector.
dr = radius/nodes;
r = [0:dr:radius];

% Timevector.
dt = t_max/steps;
t = [0:dt:t_max];

% Left convection.
T_inf_l = 200;
h_l = 100;

% Right convection.
T_inf_r = 250;
h_r = 100;

% Convection matrix.
mat_Conv = zeros(2,2);
mat_Conv(1,1) = h_l;
mat_Conv(2,1) = h_r;
mat_Conv(1,2) = T_inf_l;
mat_Conv(2,2) = T_inf_r;

% Temperature matrix.
T_0 = 600;
N = size(r,2) + 2;
I = size(t,2);
T = zeros(I, N);
E = zeros(I,1);
T = T + T_0;    % Initial T distribution.

% Matrix of temperatures using the known properties.
T_t = BC_Thermal(K_a_t, K_b_t, T, radius, dr, dt, rhoCp, mat_Conv);

% Loop through different K_a, K_b values.
K_a_v = [10:1:20];
K_b_v = [10:1:20];
T_best = zeros(I, N);
K_a_best = 0;
K_b_best = 0;
error_best = 10000;

% Matrix of temperatures for each pair of K values.
for K_a_i = K_a_v
    for K_b_i = K_b_v
        
        T_i = BC_Thermal(K_a_i, K_b_i, T, radius, dr, dt, rhoCp, mat_Conv);
        error = BC_Error(T_t, T_i);
        
        if error < error_best
            error_best = error;
            K_a_best = K_a_i;
            K_b_best = K_b_i;
            T_best = T_i;
            disp(error)
        end
        
    end
end

% Extracting the first and last node from T_t and T_best.
% Transposed as rows.
T_t_beg = T_t(:,2)';
T_t_end = T_t(:,end-1)';

T_best_beg = T_best(:,2)';
T_best_end = T_best(:,end-1)';

[X,Y] = meshgrid(r,t);
h1 = figure(1);
surf(X,Y,T_t(1:I,2:N-1));
shading flat;
xlabel('x, m');
ylabel('y, m');
zlabel('T, K');
colorbar;
grid on;
saveas(h1,[tnow '_temp_contour.fig']);
print('-dpng',[tnow '_temp_contour']);

[X,Y] = meshgrid(r,t);
h2 = figure(2);
contour(X,Y,T_best(1:I,2:N-1),40);
xlabel('x, m');
ylabel('y, m');
zlabel('T, K');
colorbar;
grid on;
saveas(h2,[tnow '_temp_contour.fig']);
print('-dpng',[tnow '_temp_contour']);

% h3 = figure(3);
% semilogy(E);
% xlabel('Number of iterations, -');
% ylabel('Maximum error, °C');
% grid on;
% saveas(h3,[tnow '_error.fig']);
% print('-dpng',[tnow '_error']);
% 
% h4 = figure(4);
% plot(x, T(round(size(T,1)/2),2:s1+1));
% legend(['y = ' num2str(y(round(size(T,1)/2),1)) 'm']);
% xlabel('x, m');
% ylabel('y, °C');
% saveas(h4,[tnow '_Tx.fig']);
% print('-dpng',[tnow '_Tx']);

p1.IN.t_max = t_max;
p1.IN.steps = steps;
p1.IN.radius = radius;
p1.IN.nodes = nodes;
p1.IN.K_a_t = K_a_t;
p1.IN.K_b_t = K_b_t;
p1.IN.rhoCp = rhoCp;
p1.IN.T_inf_l = T_inf_l;
p1.IN.h_l = h_l;
p1.IN.T_inf_r = T_inf_r;
p1.IN.h_r = h_r;
p1.IN.T_0 = T_0;

p1.OUT.T_best = T_best;
p1.OUT.error_best = error_best;
p1.OUT.K_a_best = K_a_best;
p1.OUT.K_b_best = K_b_best;

save([tnow '_p1'], 'p1');