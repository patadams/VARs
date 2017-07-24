function Z = SimulatePredDistBVAR_NIW(BVAR_NIW, Yinit, H, num_draws)
% Returns a sample of size num_draws and length H from the posterior
% predictive distribution of a Bayesian Vector Autoregression (BVAR) with
% a Normal-Inverse Wishart (NIW) prior, conditional on the p observations
% stored in Yinit.
%
% ---------
% ARGUMENTS
% ---------
% 
% Here n and p denote the number of variables and lags included in the
% BVAR.
% 
% BVAR_NIW:  struct containing posterior hyperparameters for a BVAR with
%            NIW prior.
% Yinit:     p-by-n matrix containing initial p observations used in
%            forecasting.
% H:         integer, number of periods into future to forecast.
% num_draws: integer, number of draws to make from the posterior predictive
%            distribution.

n = size(Yinit, 2);

% Draw sample from posterior distribution of parameters.
[B_draws, Sigma_draws] = SamplePosteriorBVAR_NIW(BVAR_NIW, num_draws);

% Draw from predictive distribution of future observations, conditioning
% on the parameter draws from the previous step.
Z = zeros(H, n, num_draws);
for i = 1:num_draws
    B_draw = squeeze(B_draws(:, :, i));
    Sigma_draw = squeeze(Sigma_draws(:, :, i));
    Z(:, :, i) = SimulateVAR(H, B_draw, Sigma_draw, Yinit, 'drop_init');
end

end
