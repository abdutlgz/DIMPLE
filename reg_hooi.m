function [Xhat, U, W] = reg_hooi(X, r1, r3, tol, max_iter, delta1, delta2)
    % INPUT:
    % X: input tensor of size n x n x L
    % r1, r3: ranks for U and W
    % max_iter: maximum number of iterations
    % delta1, delta2: regularization parameters
    %
    % OUTPUT:
    % U, W: estimated matrices U and W
    
    [n, ~, L] = size(X);

    U = zeros(n,r1);
    W = zeros(L,r3);
    
    
    Xmat = reshape (X,[L,n*n]); 
    [Wt,~,~] = svd(Xmat, 'econ'); % Wt: L x L
    W = Wt(:,1:r3);  % W0: L x r3
    %disp(size(W0))
    Xmat = reshape (X,[n,n*L]); 
    [Ut,~,~] = svd(Xmat, 'econ'); % Ut: n x n
    U = Ut(:,1:r1);  % U0: n x r1
    %disp(U)    
    %disp(W)
    % Main loop for HOOI with regularization

function U = Regularize(U, delta)
    % Regularize a matrix U according to the regularization method described
    % matrix U: l x k
    % delta
    % U is the result
    [l, k] = size(U);
    un =  sqrt(sum(U.^2,2)) ;      % vector of row norms
    und = min(delta*ones(l,1), un)./un;    % minimum of delta and row norms divided by row norms
    U = U.*(und*ones(1,k));
end

    for iter = 1:max_iter
        
        % Apply regularization
        U = Regularize(U, delta1);
        W = Regularize(W, delta2);

        % Update U
        M1 = ttm(tensor(X), { U', W'}, [2, 3]);
        size_vector = size(M1);
        m1 = size_vector(1);
        m2 = size_vector(2);
        m3 = size_vector(3);
        M1 = reshape(M1, [m1, m2 * m3]);
        M1 = double(M1);
        [Ut,~,~] = svd(M1);
        Ut = Ut(:, 1:r1);
        %commments:
        %Ut = ttm(tensor(X), U0, 2);
        %Ut = ttm(Ut, W0, 3);
        %Ut = ttm(Ut, W0', 3);
        %[m1, m2, m3] = size(Ut);
        %Ut = reshape(Ut, [m1, m2 * m3]);
        %[Ut, ~, ~] = svd(Ut, 'econ');
        %Ut = Ut(:, 1:r1);

        % Update W
        M3 = ttm(tensor(X), {U', U'}, [1, 2]);
        size_vector = size(M3);
        k1 = size_vector(1);
        k2 = size_vector(2);
        k3 = size_vector(3);
        M3 = reshape(M3, [k3, k1*k2]);
        M3 = double(M3);
        [Wt,~,~] = svd(M3);
        %commments:
        %M3 = double(tenmat(ttm(tensor(X), {U', W'}, [2, 3]), 3));
        %[Wt,~,~] = svd(M3); 
        %Wt = Wt(:, 1:r3);
        %Wt = ttm(X, U0', 2);
        %Wt = nmodeproduct(Wt, U0', 3);
        %[m1, m2, m3] = size(Wt);
        %Wt = reshape(Wt, [m1, m2 * m3]);
        %[Wt, ~, ~] = svd(Wt, 'econ');
        Wt = Wt(:, 1:r3);
        
        Xhat = ttm(tensor(X), {Ut', Ut', Wt'}, [1,2,3]);
        Xprevhat = ttm(tensor(X), {U', U', W'}, [1,2,3]);
        if abs(norm(Xhat) - norm(Xprevhat)) < tol
            break;
        end
        U = Ut;
        W = Wt;

    end
Xhat = ttm(tensor(X), {Ut', Ut', Wt'}, [1,2,3]);
U = Ut;
W = Wt;
disp(size(Xhat))
%disp(size(Ut))
%disp(size(Wt))
end



