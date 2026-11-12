# Changelog

## Unreleased

### Changed
- The dashboard names currencies omitted from cashflow, outflows, and reporting totals because no stored exchange rate is available. Converted reporting caches are versioned so deployment recomputes totals under the new rule.
- Income and spending reports and transaction search convert with the latest stored exchange rate on or before the entry date, falling back to the earliest later rate. Amounts with no stored rate are omitted rather than treated as parity. Empty sums remain zero, while averages skip periods with no convertible amounts. Transfer matching retains its separate five-day prior-rate requirement.
