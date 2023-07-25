% HOOI program

function [Xhat,U1,U3] = hooi(X,r1,r3,del1,del3,tol,maxiter)

%--------------------------------------------------------------------------
% INPUT:
% X: inpit tensor
% r1: rank of mode 1 matricization 
% 
% OUTPUT:
%  Xhat: estimated tensor
%  U1: n x r1
%  U3: L x r3
%--------------------------------------------------------------------------

[n,~,L] = size(X);

U1 = zeros(n,r1);
U10 = zeros(n,r1);
U3 = zeros(L,r3);
U30 = zeros(L,r3);


Xmat3 = reshape (X,n*n,L); 
[~,~,U3t] = svd(Xmat3); % U3t: L x L
U30 = U3t(:,1:r3);  % U30: L x r3

Xmat1 = reshape (X,n,L*n); 
[U1t,~,~] = svd(Xmat1); % U1t: n x n
U10 = U1t(1:r1,:);  % U10: n x r1

while tol or maxiter
% repeat   until tolerance or the number of itereations are met  iter = 1:maxiter
%     Xt3 = product of X and U30 in mode 3 
%     do SVD
%     do projection (use del3)
%     then, the same in mode 1
%     do SVD
%     do projection (use del1)
%     check tolerance. If it is met, get out of a loop 
%      
