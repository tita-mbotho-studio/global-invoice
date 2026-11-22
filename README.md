# Global Invoice

Offline-first Flutter invoicing app for freelancers and microbusinesses worldwide.

**Milestone 01 is a foundation preview, not production invoicing software.** Only local one-line drafts are supported; no PDF exports, issued invoices, tax compliance, payments, or deployment.

## Windows PowerShell

Install Flutter 3.50 stable, Android SDK, and Git. Run:

    flutter doctor -v
    git clone https://github.com/tita-mbotho-studio/global-invoice.git
    cd global-invoice
    git switch implementation/01-flutter-foundation
    powershell -ExecutionPolicy Bypass -File .\bootstrap.ps1
    flutter devices
    flutter run

The script generates Android platform files if needed, resolves dependencies, runs Drift code generation, analysis, and tests. The development package ID is temporary; choose the final unique Android application ID before publication.

## Development policy

Implement each milestone on its own branch. Do not merge, deploy, or publish without approval. GitHub Actions is manual-only. See docs/ARCHITECTURE.md.

**Verification:** Flutter was not available in the authoring environment; compilation and execution require local or CI verification.
