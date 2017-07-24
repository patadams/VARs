% Set file paths
path_VARs = '/Users/patrickadams/Documents/FRBNY/VARs/';
addpath([path_VARs, filesep, 'General'])
addpath([path_VARs, filesep, 'BVAR_NIW'])

%% Estimation
% Load Stock and Watson (2008) dataset, obtained from replication files of
% Giannone, Lenza, and Primiceri (2015).
load('DataSW.mat')
[T, n] = size(y);

% Set prior hyperparameters
p = 4;
lambda = 0.2;
diagPsiPrior = (0.02)^2 * ones(1, 7);

% Estimate BVAR with Minnesota prior
BVAR_Minn = EstimateBVAR_Minn(y, p, lambda, diagPsiPrior);

%% Forecasting
% Forecast 8 quarters ahead
H = 8;
num_draws = 5000;
Z = SamplePredDistBVAR_NIW(BVAR_Minn, y((end - p + 1):end, :), H, num_draws);
forecasts = mean(Z, 3);

% Construct 95% confidence intervals
prctile025 = prctile(Z, 2.5, 3);
prctile975 = prctile(Z, 97.5, 3);

% Draw the 95% confidence intervals in 'clockwise' order, i.e. plot
% 97.5% upper bounds from h = 1 to h = H, then plot 2.5% lower bounds from
% h = H to h = 1. Line below sets x-coordinates.
xconf = (T + 1):(T + H); xconf = [xconf, fliplr(xconf)];

% Colors for plots.
colors = get(gca, 'colororder');
gray = 0.9 * ones(1, 3);

% For each series, plot historical data, forecast, and confidence interval.
for i = 1:n
    figure
    hold on;
    title(['BVAR Forecast of ', ShortDescr{i}])
    axis([1, T + H, -Inf, Inf])
    
    % See above for explanation of 'clockwise' confidence interval plotting
    % procedure. Lines below set y-coordinates and plot CIs.
    yconf = [prctile025(:, i)', fliplr(prctile975(:, i)')];
    fill(xconf, yconf, gray, 'EdgeColor', 'None');
    
    % Plot data (solid) and forecasts (dotted).
    plot(1:(T + H), [y(:, i); NaN(H, 1)], 'color', colors(i, :))
    plot(1:(T + H), [NaN(T - 1, 1); y(T, i); forecasts(:, i)], '--', 'color', colors(i, :))
    
    hold off;
end
