# E-commerce-Funnel-Analysis

SQL analysis of e-commerce event log, tracing users through a purchase funnel (page view → add to cart → checkout → payment → purchase), broken down by traffic source, with user journey timing and revenue metrics.

# Files
funnel_analysis.sql — All analysis queries: funnel stage conversion, conversion by traffic source, user journey timing, and revenue metrics.
funnel_analysis_findings.md — Write-up of the results with commentary.
user_events.csv — Source data.

# Analysis Performed

1. Funnel Conversion Analysis
2. Conversion Rate by Traffic Source
3. User Journey Analysis
4. Revenue Analysis

# Key findings
- Overall funnel conversion (view → purchase): 16.5%. The largest drop-off is at the very top: only 31% of visitors ever add an item to cart. Every stage after that converts at 71%+.
- Email is the highest-converting channel by far (33.9% purchase conversion) despite being the smallest by volume. Social drives the most traffic but converts worst (6.9%).
- Purchases happen fast — users who buy take ~25 minutes on average from first page view to completed order.
- Revenue per visitor: $17.60, driven by an average order value of $106.51 across 826 orders totaling $87,975.11.

