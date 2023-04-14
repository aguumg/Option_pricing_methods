# from https://quant.stackexchange.com/questions/57780/issue-in-pricing-binary-options-using-heaviside-function-and-quantlib-python
import QuantLib as ql

def binary(S, strike_price, upper_barrier, 
                      risk_free, sigma, style):
    today = ql.Date().todaysDate()
    initialValue = S
    riskFreeTS = ql.YieldTermStructureHandle(ql.FlatForward(today, risk_free, ql.Actual365Fixed()))
    dividendTS = ql.YieldTermStructureHandle(ql.FlatForward(today, 0, ql.Actual365Fixed()))
    volatility = ql.BlackVolTermStructureHandle(ql.BlackConstantVol(today, ql.NullCalendar(), sigma, ql.Actual365Fixed()))

    process = ql.BlackScholesMertonProcess(ql.QuoteHandle(ql.SimpleQuote(initialValue)), riskFreeTS, dividendTS, volatility)
    steps = 1
    rng = "pseudorandom" # could use "lowdiscrepancy"
    numPaths = 10000
    if style == 'put':        
        option_type = ql.Option.Put
    elif style == 'call':
        option_type = ql.Option.Call
    strike_price = strike_price

    # option_type = ql.Option.Call
    # strike_price = S*down_pcg

    maturity_date = today+ ql.Period(7, ql.Days)#ql.Date(30, 1, 2023)
    exercise = ql.EuropeanExercise(maturity_date)

    payoff_vanilla=ql.PlainVanillaPayoff(option_type, strike_price)
    binary_option_vanilla = ql.VanillaOption(payoff_vanilla, exercise)

    engine = ql.MCEuropeanEngine(process, rng, steps, requiredSamples=numPaths)
    binary_option_vanilla.setPricingEngine(engine)
    price = binary_option_vanilla.NPV()
    return price