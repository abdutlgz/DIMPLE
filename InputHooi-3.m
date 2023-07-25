% Generate a random adjacency tensor

close all
clear variables

n = 200;   % Number of nodes in each layer
K = 2;    % Number of communities in each group of layers
L = 60;    % Number of layers
M = 2;    % Number of groups of layers
c = 0.4;  % Sparsity parameter for matrix B (minimum value)
d = 0.8;  % Sparsity parameter for matrix B (maximum value)
w = 0.5;  % Assortativity parameter

% Generating noisy tensor
[A, P, Z, label] = Atensor_MMLSBM(n, K, L, M, c, d, w);

% Call the HOOI function
X = P;
tol = 1e-6;
maxiter = 500;
r1 = 1 + M*(K-1);
r3 = M;
% Find true U1 and U3

%Estimating the regularization parameters del1 and del3:

% Calculate del1
deg = sum(sum(A, 2), 3);  % Node degrees
% del1 = 2 * sqrt(r1) * max(deg) / sqrt(sum(deg .^ 2));
 del1=10^(-9);

% Calculate del3
neg = sum(sum(A, 1), 2);  % Layer degrees
% del3 = 2 * sqrt(r3) * max(neg) / sqrt(sum(neg .^ 2));
 del3=10^(-9);

[Xhat, U1hat, U3hat, iter] = hooi(X, r1, r3, tol, maxiter, del1, del3);

% Display the estimated tensor
% disp('Estimated tensor Xhat:');
% disp(Xhat);
disp('Estimation error: tensor Xhat:');
disp(norm(Xhat-X,'fro')/sqrt(n^2*L));



% Display the factor matrices U1 and U3
% disp('Factor matrix estimate for U1:');
% disp(U1hat);
% disp(norm(U1*U1'-U1hat*U1hat'));


% disp('Factor matrix estimate for U3:');
% disp(U3hat);

% Display the number of iterations
fprintf('Number of iterations: %d\n', iter)
