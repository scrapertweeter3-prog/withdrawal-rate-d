/++ Salary-raise conversion arithmetic for FIRE planning.
 +
 + A raise is a pricing decision, and the math that connects the
 + negotiation number to a retirement date is short enough to audit.
 + This module keeps every step exact and explicit: the after-tax
 + investable flow, the ten-year growth of an annual contribution,
 + the spending a nest egg supports under the 4 percent withdrawal
 + rule, the nest egg a spending level requires, and the annual-pay
 + gap two starting salaries leave after identical raises compound.
 +
 + Conventions match the standard FIRE walkthroughs: contributions
 + arrive at end of year, growth compounds annually at the nominal
 + rate, and the withdrawal rule is a flat percentage of the nest egg.
 +/
module withdrawalrate;

/// Gross pay minus taxes at the marginal rate: what actually invests.
double afterTax(double gross, double marginalRate) @safe pure {
    return gross * (1.0 - marginalRate);
}

/// Future value of an end-of-year annual contribution stream.
double annuityFV(double annual, double annualRate, int years) @safe pure {
    double factor = 0.0;
    foreach (i; 0 .. years)
        factor += (1.0 + annualRate) ^^ i;
    return annual * factor;
}

/// Annual retirement spending a nest egg supports at the given rate.
double withdrawSupport(double nestEgg, double withdrawalRate) @safe pure {
    return nestEgg * withdrawalRate;
}

/// Nest egg required to fund annualSpending at the given rate.
double fireNumber(double annualSpending, double withdrawalRate) @safe pure {
    return annualSpending / withdrawalRate;
}

/// Annual-pay gap between two salaries after `years` of identical raises.
double salaryGapAfterYears(double salaryA, double salaryB,
                           double raiseRate, int years) @safe pure {
    import std.math.exponential : exp;
    return (salaryB - salaryA) * exp(years * log1p(raiseRate));
}

private double log1p(double x) @safe pure {
    import std.math.exponential : expm1, log;
    return (x == 0.0) ? 0.0 : (x == 1.0) ? 0.6931471805599453 : log(x + 1.0);
}

/// Render a dollar amount the way planning tables do: grouped, no cents.
string usd(double amount) @safe pure {
    import std.conv : to;
    import std.algorithm.iteration : map;
    import std.array : join;
    import std.string : rightJustify;
    long whole = cast(long) (amount + 0.5);
    string digits = to!string(whole);
    string grouped;
    int count = 0;
    for (int i = cast(int) digits.length - 1; i >= 0; i--) {
        grouped = digits[i] ~ grouped;
        count++;
        if (count % 3 == 0 && i > 0) grouped = "," ~ grouped;
    }
    return "$" ~ grouped;
}

unittest {
    // The article's worked example, sentence by sentence.
    // "$5,000 of base at a typical marginal rate means roughly $4,000
    //  invested per year" (20 percent marginal).
    assert(afterTax(5_000.0, 0.20) == 4_000.0);
    // "roughly $700 to $800 of that $1,000 typically arrives as
    //  investable dollars at a common marginal rate" (25 percent shown).
    assert(afterTax(1_000.0, 0.25) == 750.0);
    // "Five thousand dollars invested annually at 7 percent grows to
    //  roughly $69,000 over ten years" (end-of-year convention).
    auto fv = annuityFV(5_000.0, 0.07, 10);
    assert(fv > 69_000.0 && fv < 69_100.0);        // 69,082.24
    assert(usd(fv) == "$69,082");
    // "At a 4 percent withdrawal rate, that supports about $2,760
    //  of annual retirement spending."
    auto support = withdrawSupport(fv, 0.04);
    assert(support > 2_760.0 && support < 2_765.0); // 2,763.29
    assert(usd(support) == "$2,763");
    // "a household that spends $60,000 a year (FI number $1.5 million)".
    assert(fireNumber(60_000.0, 0.04) == 1_500_000.0);
    // "Two hires who land at $90,000 and $95,000 and each get 4 percent
    //  raises ... After ten years ... roughly $7,400 of annual pay".
    auto gap = salaryGapAfterYears(90_000.0, 95_000.0, 0.04, 10);
    assert(gap > 7_400.0 && gap < 7_402.0);         // 7,401.22
    assert(usd(gap) == "$7,401");
}
