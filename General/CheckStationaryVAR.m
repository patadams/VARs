function is_stationary = CheckStationaryVAR(B)
% Check whether the VAR with coefficient matrix B is stationary.

[k, n] = size(B);
p = round((k - 1) / n);

%F = [B(2:end, :)'; eye(n * (p - 1)), zeros(n, n * (p - 1))];
F = zeros(n * p, n * p);
F(1:n, :) = B(2:end, :)';
if p > 1
    F((n + 1):(n * (p - 1)), (n + 1):(n * (p - 1))) = eye(n * (p - 1));
end

if (all(abs(eig(F)) < 1))
    is_stationary = 1;
else
    is_stationary = 0;
end

end
