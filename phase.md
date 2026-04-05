Phase 1 — Core model + routes
- Model: ShortUrl with code (unique), target_url, created_at, expires_at (nullable), clicks, last_clicked_at, is_active (bool).
- Routes:
```
  - POST /shorten → validate URL, create code, return short URL + metadata.
  - GET /s/<code> → redirect to target_url (or return 404 if inactive/expired).
  - GET /stats/<code> → return clicks + timestamps.
  - Existing GET /health stays.
```
Phase 2 — Validation + error handling
- Validate URL format and length.
- Reject bad input with JSON errors (400), not stack traces.
- Define consistent error schema: { "error": "message", "code": "INVALID_URL" }.
- Handle invalid or inactive codes with JSON 404 (and no redirect).
- Ensure DB errors surface as JSON 500 with generic message.

Phase 3 — Reliability features
- Uniqueness: code must be unique; retry code generation on collision.
- Consistency: update clicks atomically; ensure redirect doesn’t corrupt state.
- Graceful failure: guard for missing/expired link.

Phase 4 — Tests (Bronze/Silver/Gold)
- Unit tests: code generation, URL validation, expiry logic.
- Integration tests: ```POST /shorten, GET /s/<code>, GET /stats/<code>.```
- Use pytest + pytest-cov to hit coverage targets (50% Silver, 70% Gold).
- Negative tests: invalid URL, expired link, disabled link.

Phase 5 — CI
- GitHub Actions: run pytest + coverage on every push.
- Fail build if tests fail or coverage below threshold.

Phase 6 — Documentation
- README: API examples + error codes.
- Failure Modes doc: DB down, bad input, expired link, collision.
- Chaos demo: kill container, show restart policy (restart: always already set).