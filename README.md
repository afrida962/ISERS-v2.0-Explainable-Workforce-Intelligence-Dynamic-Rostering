# ISERS v2.0 — Explainable Workforce Intelligence & Dynamic Rostering

ISERS is a launch-ready competition build for hospitality workforce operations. It combines multi-layer constraint checking, CP-SAT/global optimisation, employee preferences, response automation, location/travel-aware matching, manager review, employee self-service, workforce intelligence, and auditable workflows.

## Quick start (Windows)

1. Extract the ZIP.
2. Close any older ISERS server window using port 8000.
3. Double-click `start_windows.bat`.
4. Open `http://127.0.0.1:8000` if the browser does not open automatically.

Python 3.10+ is supported. The launcher installs local dependencies, including Google OR-Tools CP-SAT.

### Demo accounts

- Manager: `manager@isers-demo.com` / `DemoManager123!`
- Admin: `admin@isers-demo.com` / `DemoAdmin123!`
- Employee (Sara): `employee@isers-demo.com` / `DemoEmployee123!`
- Employee (John): `employee2@isers-demo.com` / `DemoEmployee123!`

## What is implemented

### Manager / operations portal
- Workforce command centre with unfilled shifts, pending offers, suspension/review counts, swaps, notifications.
- Employee CRUD, skills/certifications and expiry dates.
- Rich employee preferences: roles, weekdays, shift periods, venues, time window, travel radius, target hours.
- Approved base location for distance matching; no continuous GPS tracking.
- Availability and leave workflows.
- Venue/client requirements and venue map coordinates.
- Multi-layer roster generation with optional/global CP-SAT optimisation.
- Exact candidate blocker explanations for overrides and "why not this employee?" analysis.
- Cross-manager reservation checking across draft and published rosters.
- Server-side revalidation at override/publish time; PostgreSQL row locks where supported.
- Distance and travel-time estimates plus inter-venue travel/rest feasibility.
- Nearest eligible employee map/ranking.
- Employee shift-offer response monitoring and automatic replacement.
- Automatic employee suspension after 2 consecutive decline/expiry outcomes.
- Documented reactivation workflow with evidence upload (up to 2 MB), manager review and audit trail.
- Shift-swap marketplace with employee claim and manager approval.
- Configurable compliance rules (rest hours, consecutive days, travel-planning speed).
- Attendance against accepted/published assignments only.
- Payroll-ready CSV export.
- Workforce intelligence: fairness/workload, preference satisfaction, skill gaps, transparent demand forecast, what-if simulation.
- Audit log, notifications, admin user management and password reset.

### Employee portal
- Personal command centre and reliability history.
- Shift offers with accept/decline + deadline.
- Automatic replacement after decline/expiry.
- Own profile, skills visibility, preferences and opt-in base location.
- Availability and leave.
- Published personal roster.
- Shift-swap marketplace.
- Attendance for accepted shifts.
- Reactivation plea/evidence workflow when suspended.
- In-app notifications.

## Two-consecutive-non-acceptance policy

A decline or an expired/no-response offer counts as a non-acceptance. Acceptance resets the consecutive counter. At 2 consecutive non-acceptances:

1. Employee status becomes `suspended_non_acceptance`.
2. Any other pending offers for that employee are released and replacement automation runs.
3. The employee can still log in to submit a reactivation request with reason/evidence.
4. Manager/admin can approve, reject or request more information.
5. Approval returns status to `active` and resets the consecutive counter.

Manager cancellation, invalidated offers, approved leave, or system-released offers do not increment the counter.

## Multi-layer constraint engine

Hard constraint layers include:
1. Active employment / suspension status.
2. Exact work-position match.
3. Full-shift availability.
4. Approved leave exclusion.
5. Required skill/certification validity.
6. Cross-manager/roster overlap lock.
7. Weekly workload capacity.
8. Minimum experience.
9. Configurable rest + travel feasibility.
10. Configurable consecutive-day rule.
11. Employee travel-radius rule when approved coordinates exist.

Soft ranking includes experience, skill level, employee role/day/period/venue/time preferences, target-hours fairness, reliability, distance, and workload balance.

## Architecture

```text
Browser (HTML/CSS/JS)
        ↓ REST/JSON
FastAPI API + RBAC + CSRF
        ├─ SQLAlchemy models
        ├─ Multi-layer evaluator
        ├─ OR-Tools CP-SAT optimiser
        ├─ Offer/replacement automation
        ├─ Reliability/reactivation workflows
        ├─ Workforce intelligence
        └─ Audit/notifications
        ↓
SQLite (local) / PostgreSQL (production)
```

## Important implementation notes

- Map view uses employee-approved base coordinates and venue coordinates. It is designed for operational proximity matching, not continuous live tracking.
- Travel time is an estimate using configurable planning speed + buffer, not a live traffic API.
- Demand forecasting is a transparent moving-average heuristic using recorded staffing requirements. It is labelled as a forecast, not a guaranteed prediction.
- Reliability scoring is transparent and non-dominant. The explicit 2-consecutive-non-acceptance rule controls suspension.
- Employee preferences are soft criteria and never override safety/compliance/availability rules.
- ISERS does not silently assign an infeasible employee: unresolved positions remain unfilled and visible.

## Production deployment

Use PostgreSQL, HTTPS, secure cookies, non-demo credentials, backups and environment secrets. See `docs/DEPLOYMENT.md`. Before commercial production, review local employment/privacy rules and company policy for automated suspension, location use, retention of evidence documents and workforce decisioning.

## Verification

The package includes:
- `pytest` unit/advanced workflow tests.
- `scripts/smoke_check.py`.
- `scripts/regression_check.py`.
- `scripts/benchmark.py` with measured synthetic benchmark output in `benchmark_results.csv`.

See `docs/TEST_REPORT.md` and `docs/FEATURE_MATRIX.md`.
