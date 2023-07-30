% Generate a random adjacency tensor
n = 5;   % Number of nodes in each layer
K = 2;    % Number of communities in each group of layers
L = 4;    % Number of layers
M = 2;    % Number of groups of layers
c = 0.2;  % Sparsity parameter for matrix B (minimum value)
d = 0.8;  % Sparsity parameter for matrix B (maximum value)
w = 0.5;  % Assortativity parameter
alpha = 0.5;
tol = 1e06;  % Tolerance
max_iter = 500;
delta1 = 10;
delta2 = 10;
% Generating noisy tensor
%[A, P, Z, label] = AGDPG(n, K, L, M, c, d, w, alpha);
[A, P, Z, label] = Atensor_MMLSBM(n, K, L, M, c, d, w);

% P, A: n x n x L
 
X = P;
r1 = 1 + M*(K-1);
r3 = M;
% Compute node degrees
%deg_i = squeeze(sum(sum(A, 2), 3));

% Compute layer degrees
%neg_l = squeeze(sum(sum(A, 1), 2));

% Compute delta1
%delta1 = 2 * sqrt(r1) * max(deg_i) / sqrt(sum(deg_i .^ 2));

% Compute delta2
%delta2 = 2 * sqrt(r3) * max(neg_l) / sqrt(sum(neg_l .^ 2));

% Desired ranks for subspaces
%ranks = [3, 2];  % Example ranks, adjust as needed

 
% Compute HOOI
[T, U, W] = reg_hooi(X,r1,r3, tol, max_iter, delta1,delta2);
% Display the factor matrices U1 and U3
%disp(T);
%disp(U);
%disp(W);
%disp(ttm(tensor(T), {U, U, W}, [1, 2, 3]))
%disp(X)
diff = ttm(tensor(T), {U, U, W}, [1, 2, 3]) - tensor(X);
disp(sqrt(innerprod(diff, diff))); %Frobenius norm
%whos T



% Display the factor matrices U1 and U3
% disp('Factor matrix estimate for U1:');
% disp(U1hat);
% disp(norm(U1*U1'-U1hat*U1hat'));


% disp('Factor matrix estimate for U3:');
% disp(U3hat);

% Display the number of iterations
%fprintf('Number of iterations: %d\n', iter)
