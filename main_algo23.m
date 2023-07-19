close all
clear variables

n = 100;
LL = [50 100 150 200];
K = 3;
M = 3;
ww = [0.6 0.8 1.0 1.2];
loop = 100;
c = 0;
d = 0.8;

nwMEANw2 = zeros(4,4);
nwMEANw3 = zeros(4,4);
nwMEANb = zeros(4,4);
nwSTDw2 = zeros(4,4);
nwSTDw3 = zeros(4,4);
nwSTDb = zeros(4,4);
% nwQUw2 = zeros(4,4);
% nwQUw3 = zeros(4,4);
% nwQUb = zeros(4,4);
% nwQU_w2 = zeros(4,4);
% nwQU_w3 = zeros(4,4);
% nwQU_b = zeros(4,4);

lin = 1:K; 
error_within2  = zeros(1,loop); % error rate within each group of layer
error_within3  = zeros(1,loop);
error_between = zeros(1,loop); % error rate between layers 
tic

for i = 1:4   
    L = LL(i);
    for j = 1:4        
        w = ww(j); 
        for p = 1:loop

            [A, ~, Z, label_real] = Atensor(n, K, L, M, c, d, w);  % Z:n*K*M clustering matrices
            [~, label_between, ~] = BetweenLayerTri(A,M,K); 
            % consider permutation here and get the correct label_est_between
            [err,~,label_bet] = missclassGroups_more(label_real,label_between,M);
            mat_between = lab_to_mat(label_bet);
            error_between(p) = err/L; % "number" of misclustered layers 

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % algorithm 2:
            
            % get average of Atensor
            A_avg = groupaverage(A, label_bet, M);
            
            Z_est = spec_cluster(n, K, L, M, mat_between, A_avg);
            %Z_est: n*M clustering matrix

            mis = zeros(1,M);
            for mm = 1:M
                Z_label = Z(:,:,mm)*(lin'); % convert clustering matrix into labels
                mis(mm) = Misclassification(Z_label, Z_est(:,mm)); % error rate in each layer          
            end
            error_within2(p) = sum(mis)/M; 
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % algorithm 3:
            [Z_est] = WithinCluster(A, label_bet, K, M);
            %Z_est: n*M clustering matrix

            mis = zeros(1,M);
            for mm = 1:M
                Z_label = Z(:,:,mm)*(lin'); 
                % convert clustering matrix into labels
                mis(mm) = Misclassification(Z_label, Z_est(:,mm)); 
                % error rate in each group of layer          
            end
            error_within3(p) = sum(mis)/M;   
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
        end

        nwMEANw2(i,j) = mean(error_within2);
        nwMEANw3(i,j) = mean(error_within3);
        nwMEANb(i,j) = mean(error_between);
        nwSTDw2(i,j) = std(error_within2);
        nwSTDw3(i,j) = std(error_within3);
        nwSTDb(i,j) = std(error_between);
%         nwQUw2(i,j) = quantile(error_within2, 0.05); % get 5% quantile
%         nwQUw3(i,j) = quantile(error_within3, 0.05);
%         nwQUb(i,j) = quantile(error_between, 0.05);
%         nwQU_w2(i,j) = quantile(error_within2, 0.95); % get 5% quantile
%         nwQU_w3(i,j) = quantile(error_within3, 0.95);
%         nwQU_b(i,j) = quantile(error_between, 0.95);
        
%         fid=fopen('algorithm 1, 2 and 3_4.txt','a');
%         fprintf(fid,' ************************************************************ \n ');
%         fprintf(fid,' n = %i  K= %i  L = %i  M = %i  \n ', n, K, L, M);
%         fprintf(fid,'c = %4.2f  d= %4.2f  w = %4.2f \n ', c, d, w);  
%         
%         fprintf(fid,'mean of between layer error rate:  %f \n ', nwMEANb(i,j));
%         fprintf(fid,'mean of within layer error rate applying algorithm 2:  %f \n ', nwMEANw2(i,j));
%         fprintf(fid,'mean of within layer error rate applying algorithm 3:  %f \n ', nwMEANw3(i,j));
%         
%         fprintf(fid,'std of between layer error rate:  %f \n ', nwSTDb(i,j));
%         fprintf(fid,'std of within layer error rate applying algorithm 2:  %f \n ', nwSTDw2(i,j));
%         fprintf(fid,'std of within layer error rate applying algorithm 3:  %f \n ', nwSTDw3(i,j));
        
%         fprintf(fid,'0.05 quantile of between layer error rate:  %f \n ', nwQUb(i,j));
%         fprintf(fid,'0.05 quantile of within layer error rate applying algorithm 2:  %f \n ', nwQUw2(i,j));
%         fprintf(fid,'0.05 quantile of within layer error rate applying algorithm 3:  %f \n ', nwQUw3(i,j));
%         
%         fprintf(fid,'0.95 quantile of between layer error rate:  %f \n ', nwQU_b(i,j));
%         fprintf(fid,'0.95 quantile of within layer error rate applying algorithm 2:  %f \n ', nwQU_w2(i,j));
%         fprintf(fid,'0.95 quantile of within layer error rate applying algorithm 3:  %f \n ', nwQU_w3(i,j));
%         fprintf(fid,' ************************************************************ \n ');
%         fprintf(fid,' \n');
%         fclose(fid);

    end
end



toc
