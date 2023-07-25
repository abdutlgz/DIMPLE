%--------------------------------------------------------------------------
% INPUT:
% n: number of nodes in each layer
% L: number of layers
% M: number of groups of layers
% K: number of communities in each group of layers
% c, d: sparsity parameters for matrix B
% w: assortativity parameter
% alpha: coefficient for Dirichlet distribution
% OUTPUT:
% A: adjacency tensor, n*n*L
% P: Z*B*Z^T probabilities of connection, n*n*L
% label: between layer clustering label, vector form, L*1
%--------------------------------------------------------------------------



function [A, P, D, label] = AGDPG(n, K, L, M, c, d, alpha, w)

X = zeros(n, K, M);

for m = 1:M    
    % create random X (latent position matrix)
    a = alpha*ones(1, K);
    x = drchrnd(a,n); % Dirichlet distribution
    X(:, :, m) = x;    
end

 

label = randi([1 M],1,L);
% use Z and B create P and A matrix(adjacency matrix)
A = zeros(n, n, L);
P = zeros(n, n, L);
O = ones(n, n);


for l = 1:M

    b = (d-c)*rand(K*K, 1)+ c*ones(K*K,1); % create K*K random numbers between c and d
    b = reshape(b, K, K);
    D = (b + b')/2; 
    nondiag_D = D-diag(diag(D)); % non-diagonal entries of B
    D = w * nondiag_D + diag(diag(D));


    Pmat = X(:, :, label(l))*D*(X(:, :, label(l)))';
    Pmat = triu(Pmat) - diag(diag(Pmat));    
    P(:,:,l) = Pmat+Pmat';
     
      AA = binornd(O, Pmat); 
%      AA = Pmat;
      A(:,:,l) = AA+AA';
end

for i = 1:L
    newA(:,:,i) = A(:,:,label(i));
end
    
end
