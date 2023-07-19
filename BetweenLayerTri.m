function [Cs,idcs,U_est] = BetweenLayerTri(A,M,K)
%  clustering with a triangular matrix vectorization

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INPUT:                                               
%  A: nxnxL adjacency tensor 
%  M: layer types 
%  K: blocks in each layer
%  OUTPUT:
%  idcs: clustering function (k-means with SVD)(vector form)
%  U_est: nxnxL is the estimated left singular matrices of layers
%  Cs: clustering function matrix corresponding to idcs
%  B: nxnxL is the estimated hollowed layer tensor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[n,~,L] = size(A);
nn = floor(n*(n+1)/2);
%  B = zeros(n,n,L);
BB = zeros(nn,L); 
U_est = zeros(n,n,L);
Cs = zeros(L,M);
 
for l0 = 1:L
    AA = A(:,:,l0);
    [U1,~,~] = svd(AA);
    U2  = U1(:,1:K);
    B = U2*U2';
    U_est(:,:,l0) = B; 
    trilB = tril(B);
    temp = tril(true(size(trilB)));
    BB(:,l0) = trilB(temp);
%     BB(:,l0) = reshape(B,[n*n,1]);
end

[V1,~,~] = svd(BB');
V  = V1(:,1:M);
idcs = kmeans(V, M);

for l0 = 1:L   
   Cs(l0,idcs(l0))=1;
end
  



    

