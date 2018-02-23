%% 1D heat transfer equation solver.
% -k*Ab(T_i - T_i-1)/dx -k*Af(T_i - T_i+1)/dx -h*A_conv*(T_i - T_oo) +S = 0
% a1 = -k*Ab/dx
% a2 = -k*Af/dx
% b  = -h*A_conv
%
% Q.E.D :
% 
% a1 * T_i-1 - (a1 + a2 + b) * T_i + a2 * T_i+1 = b*T_00 + S
%
% system of linear equations in matrix form: AT = B
% A(j, :)   =   [a1_j, -(a1_j + a2_j + b_j), a2_j]
% B(j)      =   [b_j*T_00 + S]
%% physical props
clear all
h = 100;             % heat transfer coefficient. [W/m^2*K]
T_oo = 25;          % bulk temperature. [degC]
k = 120;
%% volumetric props
source = 0;         % in-cell energy source. [W]
consume = 0;        % in-cell energy consuming. [W]
%% geometry properties
nodes = 100;             % number of nodes
length = 1;              % [m]
dx = length/(nodes-1);   % [m]
r = @(X) 0.1 + X^2;      % variable radius as function of length X
%% solver initializing
x = dx;
A = zeros(nodes);
B = zeros(nodes, 1);
for nodeNum = 2:nodes-1
    for i = 1:nodes 
        backSideArea = pi*r(x - 0.5*dx)^2;
        frontSideArea = pi*r(x + 0.5*dx)^2;
        convectionArea = 2*pi*r(x)*dx;
        cb = -backSideArea*k/dx;
        cf = -frontSideArea*k/dx;
        cc = -h*convectionArea;
        A(nodeNum, i) = (i == nodeNum-1)*(cb);
        A(nodeNum, i) = A(nodeNum, i) + (i == nodeNum)*(cc + cf + cb)*-1;
        A(nodeNum, i) = A(nodeNum, i) + (i == nodeNum+1)*(cf);
        e(i) = cc;
    end
    x = x + dx;
    B(nodeNum) = -e(nodeNum)*T_oo + source - consume;
end
%% applying boundary conditions
Boundary_Condition_At_Zero = 10;
Boundary_Condition_At_End = 15;

% boundary condition: Dirichlet (constant T_0, T_end)
A(1, 1) = 1;
A(nodes, nodes) = 1;
B(1) = Boundary_Condition_At_Zero;
B(nodes) = Boundary_Condition_At_End;

% boundary condition: insulation
% A(1, 1) = 1;
% A(1, 2) = -1;
% A(nodes, nodes) = 1;
% A(nodes, nodes-1) = -1;
% B(1) = 0;
% B(nodes) = 0;

% %if/else form:
% BC_type = 'Neumann'
% if BC_type == 'Neumann'
%     A(1, 1) = 1;
%     A(1, 2) = -1;
%     A(nodes, nodes) = 1;
%     A(nodes, nodes-1) = -1;
%     B(1) = 0;
%     B(nodes) = 0;
% else if BC_type == 'Dirichlet'
%     A(1, 1) = 1;
%     A(nodes, nodes) = 1;
%     B(1) = Boundary_Condition_At_Zero;
%     B(nodes) = Boundary_Condition_At_End;
% end

%% solve AT = B
Temperature = A\B;
Temperature'
plot(ans, 'r*')