%--------------------------------------------------------------------------
% INPUT:
% n: number of nodes in each layer
% L: number of layers
% M: number of groups of layers
% K: number of communities in each group of layers

% OUTPUT:
% A: adjacency tensor, n*n*L
% P: Z*B*Z^T probabilities of connection, n*n*L
% label: between layer clustering label, vector form, L*1
%--------------------------------------------------------------------------



function [A, P, D, label] = AGDPG(n, K, L, M)

% create random D matrix (K*K)
c0 = rand(K*K*M, 1)*range([0 1]); % create random numbers between 0 and 1 
D = reshape(c0, K,K, M);

% for m = 1:M    
%     D0 = zeros(K, K);      
%     for k = 1:c0(m)
%         D0(k,k) = 1;
%     end
%     for k = (c0(m)+1):K
%         D0(k,k) = 1;
%     end
%     D(:, :, m) = D0;    
% end

label = randi([1 M],1,L);
% use Z and B create P and A matrix(adjacency matrix)
A = zeros(n, n, L);
P = zeros(n, n, L);
O = ones(n, n);


for l = 1:L    
    % create random X (latent position matrix)
    a = ones(1, n);
    X = drchrnd(a,K); % Dirichlet distribution
    % disp(X)
    Pmat = X'*D(:, :, label(l))*X;
    Pmat = triu(Pmat) - diag(diag(Pmat));
    P(:,:,l) = Pmat+Pmat';
    
    AA = binornd(O, Pmat);    
    A(:,:,l) = AA+AA';
end
