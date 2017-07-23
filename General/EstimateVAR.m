function [B, Sigma] = EstimateVAR(Y, p)
% Given data Y, estimate a VAR with p lags.

[T, n] = size(Y);
k = n * p + 1;

% Create 'X' matrix of RHS variables
X = ones(T - p, k);
for i = 1:p
    X(:, (2 + (i - 1) * n):(1 + i * n)) = Y((p + 1 - i):(T - i), :);
end
Ytrimmed = Y((p + 1):end, :);

[X Ytrimmed]

B = (X' * X) \ (X' * Ytrimmed);

if nargout > 1
    Epsilon = Ytrimmed - X * B;
    Sigma = Epsilon' * Epsilon / T;
end

end
