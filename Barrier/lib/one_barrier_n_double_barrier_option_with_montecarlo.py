import numpy as np
import pandas as pd
from scipy.stats import norm
import matplotlib.pyplot as plt
import math as m
# Based on https://medium.com/the-quant-journey/pricing-barrier-options-using-monte-carlo-simulation-791ec54263ff

def terminal_shareprice(S_0, risk_free_rate, sigma, Z, T):
    """
    Generates the terminal share price given some random normal values, z
    """
    # It returns an array of terminal stock prices.
    return S_0*np.exp((risk_free_rate-sigma**2/2)*T+sigma*np.sqrt(T)*Z)

def discounted_call_payoff(S_T, K, risk_free_rate, T):
    """
    Function for evaluating the discounted payoff of a call option
    in the Monte Carlo Estimation
    """
    # It returns an array which has the value of the call for each terminal stock price.
    # HERE IS IMPLIED THAT WE ARE INVESTING 1 ETH --> PREMIUM = S_0
    return np.exp(-risk_free_rate*T)*np.maximum(S_T / K -1, 0)

def discounted_put_call_payoff(S_T, K, risk_free_rate, T):
    """
    Function for evaluating the discounted payoff of a call option
    in the Monte Carlo Estimation
    """
    # It returns an array which has the value of the call for each terminal stock price.
    # HERE IS IMPLIED THAT WE ARE INVESTING 1 ETH --> PREMIUM = S_0
    put_payoffs = np.array([K/s -1 for s in S_T])
    return np.exp(-risk_free_rate*T)*np.maximum(np.array([0]*len(put_payoffs)),K/S_T-1, S_T/K -1)
# np.maximum((S_T - K)/S_T,(S_T - K)/S_T, 0)
# max(K/S_T -1, S_T/K -1)

def get_barrier_price(S_0, strike_num, upper_barrier, 
                      risk_free,  sigma,
                      T, dT, 
                      num_step, num_simulations, num_of_weeks):
    # terminal price is an array of size 13 to account for the 12 months plus initial value
    # it is timed by the number of steps
    term_val = [[None]*num_of_weeks]*num_steps 

    # initialise the monte carlo value, estimates and std as empty array of size number of steps
    mbarrier_val = [None]*num_steps
    mbarrier_estimates = [None]*num_steps
    mbarrier_std = [None]*num_steps
    current_time=0
    for i in range(1,num_steps+1):
        # fill out the first value with our initial stock price
        term_val[i-1][0] = np.full((num_simulations*i), S_0)

        for j in range (1,num_of_weeks):
            # update current week to reflect the weekly simulation we are currently in
#             current_week = (j-1)/(num_of_weeks-1)
            norm_array = norm.rvs(size = num_simulations*i)
            term_val[i-1][j] = terminal_shareprice(term_val[i-1][j-1],risk_free,sigma,norm_array,dT)

        # Compute discounted barrier Price of the option 
        
        mbarrier_val[i-1] = discounted_call_payoff(term_val[i-1][(num_of_weeks-1)],strike_num,risk_free,T-current_time)
        print(mbarrier_val[i-1])
        # use the above formula to calculate the values of the barrier option
        ## get array of booleans for when stock is knocked out or not
        knock_out_array = (np.max(term_val[i-1],axis = 0) < upper_barrier)
        ## times it by the value of the previously calculated barrier option
        mbarrier_val[i-1] = mbarrier_val[i-1] * knock_out_array

        # compute mean and standard deviation of entire path
        mbarrier_estimates[i-1] = np.mean(mbarrier_val[i-1])
        mbarrier_std[i-1] = np.std(mbarrier_val[i-1]/np.sqrt(i*num_simulations))

    return np.mean(mbarrier_estimates)

def get_double_barrier_price(S_0, strike_num, upper_barrier, lower_barrier,
                      risk_free,  sigma,
                      T, dT, 
                      num_step, num_simulations, num_of_periods):
    # terminal price is an array of size 13 to account for the 12 months plus initial value
    # it is timed by the number of steps
    term_val = [[None]*num_of_periods]*num_steps 

    # initialise the monte carlo value, estimates and std as empty array of size number of steps
    mbarrier_val = [None]*num_steps
    mbarrier_estimates = [None]*num_steps
    mbarrier_std = [None]*num_steps
    current_time=0
    for i in range(1,num_steps+1):
        # fill out the first value with our initial stock price
        term_val[i-1][0] = np.full((num_simulations*i), S_0)

        for j in range (1,num_of_periods):
            # update current week to reflect the weekly simulation we are currently in
            current_time = (j-1)/(num_of_periods-1)
            norm_array = norm.rvs(size = num_simulations*i)
            term_val[i-1][j] = terminal_shareprice(term_val[i-1][j-1],risk_free,sigma,norm_array,dT)
#             print(term_val[i-1][j])

        # Compute discounted barrier Price of the option 
        mbarrier_val[i-1] = discounted_put_call_payoff(term_val[i-1][(num_of_periods-1)],strike_num,risk_free,T-current_time)
#         print(mbarrier_val[i-1])
        # use the above formula to calculate the values of the barrier option
        ## get array of booleans for when stock is knocked out or not
        knock_out_array = (np.max(term_val[i-1],axis = 0) < upper_barrier) & ((np.min(term_val[i-1],axis = 0) > lower_barrier))
#         print(sum(knock_out_array))
        ## times it by the value of the previously calculated barrier option
        mbarrier_val[i-1] = mbarrier_val[i-1] * knock_out_array
#         print(np.mean(mbarrier_val[i-1]))
#         print('####################################')
        # compute mean and standard deviation of entire path
        mbarrier_estimates[i-1] = np.mean(mbarrier_val[i-1])
        mbarrier_std[i-1] = np.std(mbarrier_val[i-1]/np.sqrt(i*num_simulations))
#     print(np.mean(mbarrier_estimates))
    return np.mean(mbarrier_estimates)#, term_val, mbarrier_val
