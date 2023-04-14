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

"""
Explicación del código:

Primero, importamos las librerías necesarias: numpy para cálculos numéricos y scipy.stats.norm para funciones de distribución normal.
Definimos una función dnt_price que toma los siguientes parámetros: el precio actual del activo (S), la barrera inferior (H_l), la barrera superior (H_u), la volatilidad del activo anualizada (vol) y el drift del activo anualizado (r).
La función utiliza la fórmula analítica para el precio de una opción DNT europea, que se puede encontrar en varios libros de finanzas cuantitativas. En resumen, se calculan dos valores alpha y beta que representan la probabilidad de que el precio del activo no toque las barreras en cada extremo, y se utiliza la relación 1 - alpha - beta para calcular el precio de la opción.
El tiempo hasta el vencimiento se fija en una semana (T = 1/52).
La volatilidad y el drift se ajustan para el tiempo hasta el vencimiento (sigma = vol * np.sqrt(T), mu = r * T).
Se calculan los valores d1 y d2 para las barreras superior e inferior utilizando la fórmula de Black-Scholes (d1 = (ln(S/H) + (mu + sigma^2/2)) / sigma, d2 = d1 - sigma).
Se calculan los valores alpha y beta utilizando la fó
"""