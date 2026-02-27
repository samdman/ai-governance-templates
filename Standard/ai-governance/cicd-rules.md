# CI/CD Rules — Standard

## Standards
- No direct pushes to main.
- PR requires 1 review minimum.
- Semantic version tagging (recommended).
- Docker image must be reproducible (if used).

## Pipeline Stages
1. Restore
2. Build
3. Test
4. Format check
5. Analyzer check
6. Publish
7. Container build
8. Push
