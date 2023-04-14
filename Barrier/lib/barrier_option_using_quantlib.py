# from https://kannansi.medium.com/how-to-price-barrier-option-using-quantlib-python-ee4b1fff2448
# Barrier Option: Up-and-Out Call 
# Strike 100, Barrier 150, Rebate 50, Exercise date 4 years 
import QuantLib as ql
from QuantLib import *
#Set up the global evaluation date to today
today = ql.Date(23, 1,2023)
Settings.instance().evaluationDate = today

# Specify option
upper_pcg=1.1
down_pcg = 0.9
for pcg_ in [2,4,6,8,10]:
    upper_pcg = 1+pcg_/100
    down_pcg = 1-pcg_/100
    option = BarrierOption(Barrier.UpOut, S*upper_pcg, 0, 
                           PlainVanillaPayoff(Option.Call, S*down_pcg), 
                           EuropeanExercise(Date(1, 2, 2023)))

    # We will now pass the market data: spot price : 100, risk-free rate: 1% and sigma: 30% 
    # Underlying Price
    u = SimpleQuote(S)
    # Risk-free Rate
    r_ = SimpleQuote(r_f)
    # Sigma 
    sigma_ = SimpleQuote(sigma)

    # Build flat curves and volatility
    riskFreeCurve = FlatForward(0, TARGET(), QuoteHandle(r_), Actual360())
    volatility = BlackConstantVol(0, TARGET(), QuoteHandle(sigma_), Actual360())

    # Model and Pricing Engine
    # Build the pricing engine by encapsulating the market data in a Black-Scholes process

    # Stochastic Process
    process = BlackScholesProcess(QuoteHandle(u), 
                                  YieldTermStructureHandle(riskFreeCurve), 
                                  BlackVolTermStructureHandle(volatility))

    # Build the engine (based on an analytic formula) and set it to the option for evaluation
#     option.setPricingEngine(AnalyticBarrierEngine(process))
#     option.setPricingEngine(AnalyticBinaryBarrierEngine(process))
    option.setPricingEngine(AnalyticDoubleBarrierBinaryEngine(process))
    
    # Market Data Changes
    # Change the market data to get new option pricing. 

    # Set initial value and define h
    u0 = u.value(); h=0.01
    P0 = option.NPV()

    # Bump up the price by h
    u.setValue(u0+h)
    P_plus = option.NPV()

    # Bump down the price by h
    u.setValue(u0-h)
    P_minus = option.NPV() 

    # Set the price back to its current value
    u.setValue(u0)

    # Calculate Greeks: Delta, Gamma, Vega, Theta, Rho
    delta = (P_plus - P_minus)/(2*h)
    gamma = (P_plus - 2*P0 + P_minus)/(h*h)

    # Update quote for rho calculation
    r0 = r_.value(); h1 = 0.0001
    r_.setValue(r0+h); P_plus = option.NPV()
    r_.setValue(r0)

    # Rho
    rho = (P_plus - P0)/h1

    # Update quote for sigma calculation
    sigma0 = sigma_.value() ; h = 0.0001
    sigma_.setValue(sigma0+h) ; P_plus = option.NPV()
    sigma_.setValue(sigma0)

    # Vega
    vega = (P_plus - P0)/h

    # Update quote to calculate theta
    Settings.instance().evaluationDate = today+7
    P1 = option.NPV()
    h = 1.0/365

    # Theta
    theta = (P1-P0)/h
    
    print(S/P1)