# from https://www.codearmo.com/python-tutorial/binary-options-and-implied-distributions
def monte_carlo_binary(S, strike, barrier, T, r, r_f, sigma, Q, 
                       type_='call', Ndraws=10_000, seed=0):
    np.random.seed(seed)
    dS = np.random.normal((r-sigma**2/2)*T, sigma*np.sqrt(T),size=Ndraws)
    ST = S *np.exp(dS) 
    if type_ =='call':
#         value = 0
#         for i in ST:
#             if i<barrier:
# #                 print(i)
#                 value += max(i-strike,0)
        return np.exp(-r_f*T) * len(ST[ (barrier>ST) & (ST>strike)])/Ndraws
#         return len(ST[ST>strike])/Ndraws * Q *np.exp(-r_f*T)
    elif type_ == 'put':
        return np.exp(-r_f*T) * len(ST[ (strike>ST) & (ST>barrier)])/Ndraws
#         return len(ST[ST<K])/Ndraws * Q *np.exp(-r_f*T)
    else:
        raise ValueError('Type must be put or call')