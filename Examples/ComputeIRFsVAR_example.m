% Set file paths
path_VARs = '/Users/patrickadams/Documents/FRBNY/VARs/';
addpath([path_VARs, filesep, 'General'])

n = 2;
p = 1;
B_1 = [0.5, 0.8; 0, 0.3];
B = [zeros(2, 1), B_1]';
Sigma = [1, 0.5; 0.5, 1];

H = 10;
irf = ComputeIRFsVAR(B, Sigma, H, [2, 1]);

colors = get(gca, 'colororder');
for i = 1:n
    figure
    for j = 1:n
        subplot(n, 1, j)
        plot(0:H, irf(:, j, i), 'color', colors(j, :))
        if j == 1
            title(strcat('Impulse responses to variable ', num2str(i)))
        end
    end
end