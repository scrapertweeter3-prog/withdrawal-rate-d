# withdrawal-rate

Salary-raise conversion arithmetic for FIRE planning, in D. Pure Phobos,
standard library only, nothing to install beyond a D compiler. An offer
arrives as a single figure and usually gets a shrug in one direction or the
other; the chain from that figure to a retirement date is a short set of
five functions, short enough to check line by line.

The conventions follow
[the raise-to-retirement math behind the calculator](https://firenomics.com):
contributions land at year end, compounding runs annually at the nominal
rate, and the 4 percent rule is applied as a straight share of the
accumulated balance.

## The worked example

One $5,000 raise, audited end to end:

- Investable after a 20% marginal rate: `afterTax(5_000, 0.20)` =
  $4,000 per year. (At a 25% rate, the same raise keeps $3,750.)
- Ten years at 7% with the full $5,000 invested each year:
  `annuityFV(5_000, 0.07, 10)` = $69,082.
- Annual retirement spending that nest egg supports at a 4% withdrawal rate:
  `withdrawSupport(69_082, 0.04)` = $2,763.
- Nest egg a $60,000 spending level needs at 4%:
  `fireNumber(60_000, 0.04)` = $1,500,000.
- Two hires at $90,000 and $95,000 taking identical 4% raises:
  `salaryGapAfterYears(90_000, 95_000, 0.04, 10)` = $7,401 of annual pay
  after ten years. Because the dollar gap compounds with the raises, it
  never stops widening without a second negotiation.

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

`usd` prints grouped whole-dollar strings, the format monthly-spending
tables use. Everything runs in plain doubles: at the precision these
decisions need, the rounding is a display concern, not a math one.

## Verify

```
dub test
```

The unit tests reproduce every figure in this page from the inputs: the
$69,082 ten-year growth, the $2,763 withdrawal support, the $1.5M FI number,
and the $7,401 ten-year salary gap.

## License

MIT. See [LICENSE](https://github.com/scrapertweeter3-prog/withdrawal-rate-d/blob/main/LICENSE).
