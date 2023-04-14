function P2 = bn_p2(K, B, phi, psi)
% BN_P2 evaluates the expectation P2 in the Borovkov-Novikov theorem.
%
%   P2 = BN_P2(K, B, phi, psi) returns the value of the expectation
%       P2 = E[max(exp(X)-K,0) ; Z <= B]
%   with
%       K   : real number
%       B   : real number
%       phi : mgf of X
%       psi : joint mgf of (X,Z)
a=9;
g = @(s) bn_g(a, log(K), s);
P1 = bn_p1(K, phi);
integrand = @(x, u, v) 1./(1i*u).*psi(1+a-1i*v,1i*u).*g(v).*exp(-1i*u*x);
W = @(x) 1/2 - 1/(4*pi^2*P1)...
    *integral2(@(u, v) integrand(x, u, v), -Inf, Inf, -Inf, Inf);
P2 = P1*W(B);