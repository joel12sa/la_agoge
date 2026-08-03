# Notes

## Fixes applied
- Updated `@v2` tag to `@v1` (the action only has tags `v1`, `v1.7.x`; `v2` does not exist)
- Corrected input name from `serviceAccountJsonContent` to `serviceCredentialsFileContent` (matches action docs)
- Simplified releaseNotes fallback to use only `github.event.commits[0].message` (no pull_request.title on push)

## To make this work
1. Ensure you have a Firebase project with App Distribution enabled
2. Add the required secrets/vars to GitHub:
   - `FIREBASE_SERVICE_ACCOUNT_JSON` (JSON content from Firebase service account)
   - `FIREBASE_APP_ID` (from Firebase console)
   - `FIREBASE_TESTER_GROUPS` (e.g., `testers`)
3. Push to `main` or trigger manually via Actions tab

> Note: This pipeline uses debug signing; not suitable for production release. Use a real keystore later.