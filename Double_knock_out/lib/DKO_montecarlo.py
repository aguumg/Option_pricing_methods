# from https://www.codearmo.com/python-tutorial/binary-options-and-implied-distributions
# IT IS THE PRICE FOR PREMIUM = 1a
def monte_carlo_DKO(S, K_L, K_U, T, r,r_f, sigma, 
                       Ndraws=10_000, seed=0, style='european'):
    np.random.seed(seed)
    if style == 'european':
        dS = np.random.normal((r-sigma**2/2)*T, sigma*np.sqrt(T),size=Ndraws)
        ST = S *np.exp(dS) 
        in_the_moneyness = len(ST[(ST>K_L) & (ST<K_U)])
        return in_the_moneyness/Ndraws * np.exp(-r_f*T)
    elif style == 'american':
        in_the_moneyness = 0
        for i in range(Ndraws):
            path = [S]
            knocked_out = False
            for j in range(T):
                dS = np.random.normal((r-sigma**2/2)*1, sigma*np.sqrt(1))
#                 print(dS)
                if (path[j]*(1+dS) > K_U) | (path[j]*(1+dS) < K_L):
                    knocked_out = True
                path.append(path[j]*np.exp(dS))
#             print(knocked_out)
#             print(path)
            if not knocked_out:
                in_the_moneyness += 1
        return in_the_moneyness/Ndraws * np.exp(-r_f*T)
#     elif type_ == 'put':
#         return len(ST[ST<K])/Ndraws *Q*np.exp(-r*T)
#     else:
#         raise ValueError('Type must be put or call')
    