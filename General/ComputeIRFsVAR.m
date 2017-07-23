function irf = ComputeIRFsVAR(B, Sigma, H, orthogonalize)
% Compute impulse response functions for a VAR with parameters {B, Sigma}.
% These IRFs are not standardized!
% The estimated IRFs are stated in terms of deviations from steady states,
% which requires the VAR to be stationary.
%
% irf(h + 1, j, i) = d y_j,t+h / d eps_i,t

[k, n] = size(B);
p = round((k - 1) / n);

if ~CheckStationaryVAR(B)
    error('The given VAR is not stationary.')
end

B = B(2:end, :); % drop first column from B (constant not needed)

irf = zeros(H + 1, n, n); 

for i = 1:n
    % Compute impulse responses with respect to eps_i,t
    x = zeros(n * p, 1);
    x(i) = 1;
    y = x(1:n);
    irf(1, :, i) = y';
    for h = 1:H
        y = B' * x;
        irf(h + 1, :, i) = y';
        if p == 1
            x = y;
        else
            x = [y; x(1:(n * (p - 1)))];
    end
end

if orthogonalize
    % Orthogonalize IRFs
    A = ldl(Sigma);
    for h = 0:H
        irf(h + 1, :, :) = squeeze(irf(h + 1, :, :)) * A;
    end
end

end
        
