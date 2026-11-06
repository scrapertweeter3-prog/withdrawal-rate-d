# withdrawal-rate

Salary-raise conversion arithmetic for FIRE planning, in D. Pure
Phobos, standard library only, nothing to install beyond a D compiler.
It exists because a raise gets quoted as a single number and accepted
or dismissed on gut feel, when the whole chain from that number to a
retirement date is five functions long and worth auditing directly.

The conventions follow
[the conversion math that reprices a raise](https://firenomics.com):
end-of-year contributions, annual compounding at the nominal rate,
and the 4 percent withdrawal rule as a flat percentage of the nest egg.

## The worked example

One $5,000 raise, audited end to end:

- Investable after a 20% marginal rate: `afterTax(5_000, 0.20)` =
  $4,000 per year. (At a 25% rate, $1,000 of base keeps $750.)
- Ten years at 7% with the full $5,000 invested:
  `annuityFV(5_000, 0.07, 10)` = $69,082.
- Retirement spending that supports at a 4% withdrawal rate:
  `withdrawSupport(69_082, 0.04)` = $2,763 per year.
- Nest egg a $60,000 spending level needs at 4%:
  `fireNumber(60_000, 0.04)` = $1,500,000.
- Two hires landing at $90,000 and $95,000 with identical 4% raises:
  `salaryGapAfterYears(90_000, 95_000, 0.04, 10)` = $7,401 of annual
  pay after ten years. The annual-pay gap compounds with the salary,
  so it keeps widening with no second negotiation.

## The API

```d
import withdrawalrate;

afterTax(5_000.0, 0.20);                    // 4,000.0
annuityFV(5_000.0, 0.07, 10);               // 69,082.24
withdrawSupport(69_082.24, 0.04);           // 2,763.29
fireNumber(60_000.0, 0.04);                 // 1,500,000.0
salaryGapAfterYears(90_000.0, 95_000.0, 0.04, 10);  // 7,401.22
usd(annuityFV(5_000.0, 0.07, 10));          // "$69,082"
```

`usd` renders grouped whole-dollar strings the way planning tables do.
Everything runs in plain doubles: at planning-table precision the
rounding is in the display, not the decisions.

## Verify

```
dub test
```

The unit tests reproduce every figure in this README from the inputs,
including the $69,082 ten-year growth, the $2,763 withdrawal support,
the $1.5M FI number, and the $7,401 ten-year salary gap.

## License

MIT.
