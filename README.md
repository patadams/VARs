This repository contains various MATLAB functions to simulate, estimate, and
forecast using Vector Autoregressions (VARs).
VARs provide a flexible framework for modeling the joint dynamics of several
time series.
A VAR with $n$ variables and $p$ lags can be written as
$$ y_t = C + B_1 y_{t-1} + ... + y_{t-p} + \epsilon_t$$
where $y_t = (y_{1,t},...,y_{n,t})'$ is a vector containing the $n$ variables,
and $\epsilon_t$ is a vector white noise process with mean $0$ and
covariance matrix $\Sigma$.

Because of their dense parameterization, VARs often generate improved
out-of-sample forecasting results when estimated using Bayesian methods.
The functions provided in the folder "BVAR_NIW" implement Bayesian estimation
and forecasting of VARs using the conjugate Normal-Inverse Wishart prior.
