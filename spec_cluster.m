%-------------------------------------------------------
% function Z = spec_cluster(G)  (within layer clustering)
% Input:
% Cmat: clustering matrix c
% T:    estimated tensor put to multiply W
% n, K, L, M: layer parameters
% Output:
% Z: within layer clustering matrix/label
% m_th column of Z is a clustering label function(vector form) for m_th layer group
% and its corresponding matrix form is Z(m), m_th matrix in Z tensor from
% output of Atensor.m
%-------------------------------------------------------

function Z = spec_cluster(n, K, L, M, Cmat, T)

W = Cmat/(sqrtm(Cmat'*Cmat));   
T = reshape(T, n^2, L);
H = T*W;
H = reshape(H, n, n, M);

Z = zeros(n,M);
for m = 1:M
    [U, ~, ~] = svd(H(:, :, m));
    U = U(:, 1:K);    
    Z(:,m) = kmeans(U, K);
end



