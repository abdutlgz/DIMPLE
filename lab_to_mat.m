function Mat = lab_to_mat(idx)
% get the matrix form of the index
% ex. idx = [1 2 2 1] -> mat = [[1 0], [0 1], [0 1], [1 0]]

L = max(size(idx));
num = max(idx);
Mat = zeros(L, num);

for l = 1:L
    label = idx(l);
    for m = 1:num
        if m == label
            Mat(l, m) = 1;
        end
    end
end