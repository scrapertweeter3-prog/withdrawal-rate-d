/// Demo: one raise, audited end to end. Run: dub run --config=demo  (see dub.sdl)
import std.stdio;
import withdrawalrate;

void main() {
    writeln("One $5,000 raise, audited:");
    writeln("  investable after a 20% marginal rate: ",
            usd(afterTax(5_000.0, 0.20)), " per year");
    writeln("  ten years at 7% (full $5,000 invested): ",
            usd(annuityFV(5_000.0, 0.07, 10)));
    writeln("  retirement spending supported at 4%:   ",
            usd(withdrawSupport(annuityFV(5_000.0, 0.07, 10), 0.04)), " per year");
    writeln("  nest egg a $60,000 spending level needs at 4%: ",
            usd(fireNumber(60_000.0, 0.04)));
    writeln("  $90,000 vs $95,000 start, 4% raises, ten years on: annual gap ",
            usd(salaryGapAfterYears(90_000.0, 95_000.0, 0.04, 10)));
}
