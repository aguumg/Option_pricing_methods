import numpy as np
from scipy.stats import norm

def dnt_price(S, H_l, H_u, vol, r):
    """
    Calculates the price of a Double Not Touch (DNT) option with European exercise style.
    
    Parameters:
    S : float
        Current price of the underlying asset.
    H_l : float
        Lower barrier.
    H_u : float
        Upper barrier.
    vol : float
        Annualized volatility of the underlying asset.
    r : float
        Annualized drift of the underlying asset.
        
    Returns:
    float
        Price of the DNT option.
    """
    T = 1/52 # Time to expiration (1 week)
    sigma = vol * np.sqrt(T)
    mu = r * T
    d1_l = (np.log(S/H_l) + (mu + sigma**2/2)) / sigma
    d2_l = d1_l - sigma
    d1_u = (np.log(S/H_u) + (mu + sigma**2/2)) / sigma
    d2_u = d1_u - sigma
    alpha = (H_u/S)**(2*r/(vol**2)) * norm.cdf(d1_u) - (H_l/S)**(2*r/(vol**2)) * norm.cdf(d1_l)
    beta = (H_u/S)**(2*(r+vol**2)/(vol**2)) * norm.cdf(d2_u) - (H_l/S)**(2*(r+vol**2)/(vol**2)) * norm.cdf(d2_l)
    price = S * (1 - alpha - beta)
    return price
