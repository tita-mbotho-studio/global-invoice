# Milestone 01 architecture

- app: navigation, theme and shell
- core: reusable layout
- features/invoices/domain: exact decimal invoice calculations
- features/invoices/data: Drift SQLite and repository abstraction
- features/*/presentation: Flutter screens

**Current scope:** create/list/delete single-line invoice drafts offline. This is not a legally issued invoice.

**Financial rules:** extended line amounts rounded to currency scale, tax rounded once on summed subtotal. This is a starter policy, not globally compliant tax logic. Replace incomplete currency metadata and add jurisdiction-specific policy before launching worldwide.

**Future gates:** migrations, immutable issued snapshots, safe numbering, payment tracking, currency data, PDFs, data backups, localization, security, purchases, accessibility and performance testing.

**Release:** use a permanent app ID, commit Android platform code and pubspec.lock after successful bootstrap. No automatic deploy.
