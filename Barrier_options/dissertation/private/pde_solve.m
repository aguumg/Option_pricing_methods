function [u0, U] = pde_solve(mod, opt, M, N)
% PDE_SOLVE solves the Black-Scholes PDE numerically on a bounded domain.
%
%   [u0, U] = PDE_SOLVE(mod, opt, M, N) returns u0 = u(0,S0), where u
%   solves the Black-Scholes partial differential equation with boundary
%   conditions u(t,L) = u(t,U) = 0 for 0 <= t < T and u(T,x) = h(x) for
%   L <= x <= U, and V the full numerical solution to this partial differential 
%   equation. V is calculated by using a finite differences scheme with [0,T] 
%   divided into N pieces and the domain [L,U] divided into M pieces. P is 
%   calculated by linear interpolation.
%
%   The struct mod must contain the fields
%       S0     : Initial value
%       r      : Risk-free interest
%       sigma  : Volatility
%
%   The struct opt must contain the fields
%       T      : Time to maturity
%       h      : Function of terminal value, describing payoff at maturity
%       L      : Lower boundary
%       U      : Upper boundary

% Time step
dt = opt.T/N;
% Space step
dx = (opt.U - opt.L)/M;

% Initialize solution matrix
xs = opt.L:dx:opt.U;
U = zeros(M+1,N+1);
U(2:end-1, end) = opt.h(xs(2:end-1));

% Create matrix from matrix representation of system of linear equations.
a = @(x) dt*(mod.r*x/(2*dx) - mod.sigma^2*x.^2/(2*dx^2));
b = @(x) 1 + mod.r*dt + mod.sigma^2*x.^2*dt/dx^2;
c = @(x) -dt*(mod.r*x/(2*dx) + mod.sigma^2*x.^2/(2*dx^2));
D = zeros(M-1);
D(2:M:end) = a(xs(3:M));
D(1:M:end) = b(xs(2:M));
D(M:M:end) = c(xs(2:M-1));

for n = N:-1:1
    % Solve system of linear equations
    U(2:end-1, n) = D\U(2:end-1, n+1);
end

% Interpolate
u0 = interp1(xs, U(:,1), mod.S0);