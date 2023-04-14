function [v0, V] = log_pde_solve(mod, opt, M, N)
% LOG_PDE_SOLVE solves the log transformed Black-Scholes PDE numerically on a 
% bounded domain.
%
%   [v0, V] = LOG_PDE_SOLVE(mod, opt, M, N) returns v0 = v(0,x0), where v
%   solves the log transformed Black-Scholes partial differential equation with 
%   boundary conditions v(t,L) = v(t,U) = 0 for 0 <= t < T and v(T,x) = h(x) for
%   L <= x <= U, and V the full numerical solution to this partial differential
%   equation. V is calculated by using a finite differences scheme with [0,T] 
%   divided into N pieces and the domain [L,U] divided into M pieces. P is 
%   calculated by linear interpolation.
%
%   The struct mod must contain the fields
%       x0     : Initial value
%       r      : Risk-free interest
%       sigma  : Volatility
%
%   The struct opt must contain the fields
%       T      : Time to maturity
%       h      : Function of terminal value
%       L      : Lower boundary of domain
%       U      : Upper boundary of domain

% Time step
dt = opt.T/N;
% Space step
dx = (opt.U - opt.L)/M;

% Initialize solution matrix
xs = opt.L:dx:opt.U;
V = zeros(M+1,N+1);
V(2:end-1, end) = opt.h(xs(2:end-1));

% Create matrix from matrix representation of system of linear equations.
theta = mod.r - 1/2*mod.sigma^2;
a = dt*(theta - abs(theta))/(2*dx) - mod.sigma^2*dt/(2*dx^2);
b = 1 + mod.sigma^2*dt/dx^2 + abs(theta)*dt/dx + mod.r*dt;
c = -dt*(theta + abs(theta))/(2*dx) - mod.sigma^2*dt/(2*dx^2);
D = zeros(M-1);
D(2:M:end) = a;
D(1:M:end) = b;
D(M:M:end) = c;

for n = N:-1:1
    % Solve system of linear equations
    V(2:end-1, n) = D\V(2:end-1, n+1);
end

% Interpolate
v0 = interp1(xs, V(:, 1), mod.x0);