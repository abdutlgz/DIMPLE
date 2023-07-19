%--------------------------------------------------------------------------
% This function takes the groups resulted from spectral clutsering and the
% ground truth to compute the misclassification rate.
% groups: [grp1,grp2,grp3] for three different forms of Spectral Clustering
% s: ground truth vector
% Missrate: 3x1 vector with misclassification rates of three forms of
% spectral clustering
%-------------------------------------------------------------------------
% get the misgrouped rate between idx and z considering permutation
%--------------------------------------------------------------------------
% Copyright @ Ehsan Elhamifar, 2012
%--------------------------------------------------------------------------


function [Missrate] = Misclassification(idx,z)

n = max(z);

if (n >10)
    Missrate = 1 - compacc(idx, z'); % it is an approximate way to calculate ACC.
else
    Missrate = missclassGroups( idx,z,n ) ./ length(z);
    %Missrate = missclassGroups( groups,s,n );
    % it sometimes causes out of memory when nbcluster >10
end
