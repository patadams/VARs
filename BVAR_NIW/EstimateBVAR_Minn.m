function BVAR_Minn = EstimateBVAR_Minn(Y, p, lambda, diagPsiPrior)
% Estimate a BVAR with Minnesota prior.
% Hyperparameters lambda, diagPsiPrior are described in Giannone et al

n = size(Y, 2);
k = n * p + 1;

diagPsiPrior = reshape(diagPsiPrior, [1, n]) % convert to row vector

BPrior = [zeros(n, 1), eye(n), zeros(n, n * (p - 1))]';
diagOmegaPrior = Inf;
for l = 1:p
    diagOmegaPrior = [diagOmegaPrior, (lambda^2 / l^2) ./ diagPsiPrior];
end
OmegaPrior = diag(diagOmegaPrior);
PsiPrior = diag(diagPsiPrior);
dfPrior = n + 2;

BVAR_Minn = EstimateBVAR_NIW(Y, BPrior, OmegaPrior, PsiPrior, dfPrior);
