function [Z] = WithinCluster(AD, betweenlabel, K, M)
% this one is only for M=2

% within layer clustering algorithm 3 in our paper
% input:
% AD: adjacency tensor
% betweenlabel: between layer clustering labels
% K: number of communities in each layer
% M: number of groups 

% output:
% Z: within layer clustering labels(M groups/columns)
% Z_per: clustering labels after permutation


[n, ~, L] = size(AD);
mat_between = lab_to_mat(betweenlabel);

G_est = zeros(n,n,L);
for l = 1:L
    G_est(:,:,l) = AD(:,:,l)*AD(:,:,l) - diag(AD(:,:,l)*ones(n,1));
end

%%%%%%%%%%%%%
% get average  
G_avg = zeros(n,n,L); 
for m = 1:M
    index_label = find(betweenlabel==m); % find the index in label to be m
    I = length(index_label);    
    G_sum = G_est(:,:,index_label(1));
    if I > 1
        for i = 2:I
            G_sum = G_sum + G_est(:,:,index_label(i));
        end
    end
    for i = 1:I
        G_avg(:,:,index_label(i)) = G_sum/I;
    end
end
%%%%%%%%%%%%%

Z = spec_cluster(n, K, L, M, mat_between, G_avg);

% get the label of permutation of Z2 we want to match Z1
% Z1 = Z(:,1);
% Z2 = Z(:,2);
% [~,~,index_new2] = missclassGroups_more(Z1, Z2, K);
% Z_per = [Z1, reshape(index_new2,n,1)];


