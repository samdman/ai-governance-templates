# CI/CD Rules — Enterprise

## Standards
- No direct pushes to main.
- PR requires 1–2 reviews (team dependent).
- Semantic version tagging.
- Docker image reproducible.
- Migration checks required (backward compatible).

## Pipeline Stages
1. Restore
2. Build
3. Test
4. Format check
5. Analyzer check
6. Security scan (SAST/Dependency)
7. Publish
8. Container build
9. Push
