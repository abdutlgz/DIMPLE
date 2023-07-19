function G_avg = groupaverage(G_est, betweenlabel, M)

[n,~,L] = size(G_est);
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