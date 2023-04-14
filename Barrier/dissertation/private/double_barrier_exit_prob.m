function p = double_barrier_exit_prob(x, xprime, L, U, sigma, dt, cutoff)
% DOUBLE_BARRIER_EXIT_PROB calculates the probability of a GBM reaching L or U.
%
%   p = DOUBLE_BARRIER_EXIT_PROB(x, xprime, L, U, sigma, dt, cutoff) gives
%   the probability for a GBM S of hitting one of the barriers L and U over
%   a time period of length dt, conditional on S taking the values x and
%   xprime at the end-points. The parameter sigma specifies the volatility
%   of S. The probability is in theory given as an infinite series, and the
%   parameter cutoff specifies how many terms of this series to calculate.
y = log(xprime./x);
q = log(U/L);
a = log(x/L);
b = log(U./x);
R = @(y,z) exp(-2*z.*(z-y)/(sigma^2*dt));
p = 0;
for k = 1:cutoff
    p = p + R(y, q*k - a) + R(y, -q*k + b) - R(y, q*k) - R(y, -q*k);
end