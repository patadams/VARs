% Set file paths
path_VARs = '/Users/patrickadams/Documents/FRBNY/VARs/';
addpath([path_VARs, filesep, 'General'])
addpath([path_VARs, filesep, 'BVAR_NIW'])

%% Simulate data
% Construct VAR
T = 100;
n = 2;
p = 1;
B_1 = [0.5, 0; 0.25, 0.5];
B = [zeros(2, 1), B_1]';
Sigma = eye(2);
Yinit = zeros(1, 2);

% Simulate VAR
Y = SimulateVAR(T, B, Sigma, Yinit);

%% Estimation
% Set NIW prior
BPrior = zeros(3, 2);
OmegaPrior = 0.8 * eye(3);
PsiPrior = eye(2);
dfPrior = n + 2;

% Estimate BVAR
BVAR_NIW = EstimateBVAR_NIW(Y, BPrior, OmegaPrior, PsiPrior, dfPrior);

%% Forecasting
% Forecast H periods ahead
H = 20;
num_draws = 5000;
Z = ForecastBVAR_NIW(BVAR_NIW, Y((end - p + 1):end, :), H, num_draws);
forecasts = mean(Z, 3);

% Construct 95% confidence intervals
prctile025 = prctile(Z, 2.5, 3);
prctile975 = prctile(Z, 97.5, 3);

% Draw the 95% confidence intervals in 'clockwise' order, i.e. plot
% 97.5% upper bounds from h = 1 to h  =H, then plot 2.5% lower bounds from
% h = H to h = 1. Line below sets x-coordinates.
xconf = (T + 1):(T + H); xconf = [xconf, fliplr(xconf)];

% Colors for plots.
colors = get(gca, 'colororder');
gray = 0.9 * ones(1, 3);

% Plot data, forecast, and confidence intervals.
for i = 1:n
    subplot(n, 1, i)
    hold on;
    
    % See above for explanation of 'clockwise' confidence interval plotting
    % procedure. Lines below set y-coordinates and plot CIs.
    yconf = [prctile025(:, i)', fliplr(prctile975(:, i)')];
    fill(xconf, yconf, gray, 'EdgeColor', 'None');
    
    % Plot data (solid) and forecasts (dotted).
    plot([Y(:, i); NaN(H, 1)], 'color', colors(i, :))
    plot([NaN(T - 1, 1); Y(T, i); forecasts(:, i)], '--', 'color', colors(i, :))
    
    hold off;
end