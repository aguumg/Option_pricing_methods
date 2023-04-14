function p = single_barrier_exit_prob(x, y, N, sigma, dt)
% SINGLE_BARRIER_EXIT_PROB calculates the probability of a GBM reaching N.
%
%   p = SINGLE_BARRIER_EXIT_PROB(x, y, N, sigma, dt) gives the probability
%   for a GBM S of hitting a barrier N over a time period of length dt,
%   conditional on S taking the values x and y at the end-points. The
%   parameter sigma specifies the volatility of S.
p = exp(-2*log(x/N).*log(y/N)/(sigma^2*dt));