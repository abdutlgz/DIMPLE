%--------------------------------------------------------------------------
% INPUT:
% n: number of nodes in each layer
% L: number of layers
% M: number of groups of layers
% K: number of communities in each group of layers
% c, d: spasity parameters for matrix B
% w: assortativity parameter
% OUTPUT:
% A: adjacency tensor, n*n*L
% Z: within layer clustering indicator tensor, n*K*M
% P: Z*B*Z^T probabilities of connection, n*n*L
% label: between layer clustering label, vector form, L*1
%--------------------------------------------------------------------------



function [A, P, Z, label] = Atensor(n, K, L, M, c, d, w)

% create random Z matrix (cluster indicator matrix)
Z = zeros(n, K, M);
for m = 1:M    
    Z0 = zeros(n, K);
    c0 = randi([1 K],1,n); % create n random numbers between 1 and K    
    for N = 1:n
        Z0(N, c0(N)) = 1;
    end
    Z(:, :, m) = Z0;    
end

label = randi([1 M],1,L);
% use Z and B create P and A matrix(adjacency matrix)
A = zeros(n, n, L);
P = zeros(n, n, L);
O = ones(n, n);

for l = 1:L    
    % create random B (L cluster indicator matrices)
    b = rand(K*K, 1)*range([c d])+min([c d]); % create K*K random numbers between c and d
    b = reshape(b, K, K);
    B = (b + b')/2; 
    nondiag_B = B-diag(diag(B)); % non-diagonal entries of B
    B = w * nondiag_B + diag(diag(B));
    
    Pmat = Z(:, :, label(l))*B*(Z(:, :, label(l)))';
    Pmat = triu(Pmat) - diag(diag(Pmat));
    P(:,:,l) = Pmat+Pmat';
    
    AA = binornd(O, Pmat);    
    A(:,:,l) = AA+AA';
end
