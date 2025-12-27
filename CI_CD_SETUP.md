# 🚀 CI/CD Setup Guide

Your Shoe Store App now has complete GitHub Actions automation! Here's what's been configured:

## 📦 What's Included

### 1. **Flutter CI/CD Pipeline** (`flutter_ci.yml`)
Runs on every push and pull request to `main` or `develop` branches.

**Jobs:**
- ✅ **Analyze Code**: Checks formatting and runs static analysis
- 🏗️ **Build Android**: Builds both debug and release APKs
- 🐧 **Build Linux**: Builds Linux desktop app

**Artifacts Generated:**
- `app-debug-apk` (retained for 30 days)
- `app-release-apk` (retained for 90 days)
- `linux-build` (retained for 30 days)

### 2. **Release Workflow** (`release.yml`)
Creates GitHub releases with downloadable APKs and AABs.

**Triggers:**
- Pushing a version tag (e.g., `v1.0.0`)
- Manual workflow dispatch

**Generates:**
- Release APK (`.apk`)
- App Bundle for Play Store (`.aab`)
- Automatic release notes

### 3. **Code Quality Checks** (`code_quality.yml`)
Runs on all pull requests to ensure code quality.

**Checks:**
- ✅ Code formatting
- ✅ Static analysis
- ✅ Dependency updates check
- ✅ Test coverage
- ✅ Code metrics

### 4. **Issue & PR Templates**
Professional templates for:
- 🐛 Bug reports
- ✨ Feature requests
- 🔄 Pull requests

### 5. **Dependabot Configuration**
Automatically checks for:
- Flutter/Dart dependency updates (weekly)
- GitHub Actions updates (weekly)

---

## 🎯 How to Use

### Automatic Builds
Once you push to GitHub, workflows run automatically:

1. **Push code to main:**
   ```bash
   git push origin main
   ```
   → Triggers CI/CD pipeline
   → Builds APKs automatically
   → Uploads artifacts to GitHub Actions

2. **Create pull request:**
   → Runs code quality checks
   → Comments on PR with results

### Creating a Release

#### Method 1: Git Tag (Recommended)
```bash
# Tag the current commit
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push the tag
git push origin v1.0.0
```
→ Automatically creates GitHub release with APK and AAB

#### Method 2: Manual Workflow
1. Go to **Actions** tab on GitHub
2. Select **Create Release** workflow
3. Click **Run workflow**
4. Enter version (e.g., `v1.0.0`)
5. Click **Run workflow** button

### Downloading Build Artifacts

#### From Workflow Runs:
1. Go to **Actions** tab
2. Click on a workflow run
3. Scroll to **Artifacts** section
4. Download the APK

#### From Releases:
1. Go to **Releases** tab
2. Download APK or AAB from latest release

---

## 📊 Workflow Status Badges

Add these to your README.md to show build status:

```markdown
![CI/CD](https://github.com/YOUR_USERNAME/shoe_store_app/actions/workflows/flutter_ci.yml/badge.svg)
![Release](https://github.com/YOUR_USERNAME/shoe_store_app/actions/workflows/release.yml/badge.svg)
![Code Quality](https://github.com/YOUR_USERNAME/shoe_store_app/actions/workflows/code_quality.yml/badge.svg)
```

---

## 🔧 Workflow Configuration

### Customize Build Settings

Edit `.github/workflows/flutter_ci.yml`:

```yaml
# Change Flutter version
flutter-version: '3.24.5'  # Update to your version

# Change branches to watch
on:
  push:
    branches: [ main, develop, staging ]  # Add more branches
```

### Add More Platforms

To add iOS builds:
```yaml
build-ios:
  name: Build iOS
  runs-on: macos-latest
  steps:
    - uses: actions/checkout@v4
    - uses: subosito/flutter-action@v2
    - run: flutter build ios --release --no-codesign
```

### Configure Secrets (for Production)

For production releases, add these secrets in GitHub:
- Repository → Settings → Secrets and variables → Actions

**Needed for signed releases:**
- `ANDROID_KEYSTORE_BASE64`: Base64 encoded keystore
- `KEYSTORE_PASSWORD`: Keystore password
- `KEY_ALIAS`: Key alias
- `KEY_PASSWORD`: Key password

---

## 📝 GitHub Actions Overview

### When Do Workflows Run?

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `flutter_ci.yml` | Push/PR to main/develop | Continuous integration |
| `release.yml` | Tag push or manual | Create releases |
| `code_quality.yml` | Pull requests | Code review automation |

### Workflow Permissions

All workflows use minimal permissions:
- Read repository content
- Write artifacts
- Write releases (release workflow only)

---

## 🎓 Best Practices

### Branch Strategy
```
main (production)
  ← develop (development)
    ← feature/* (features)
    ← bugfix/* (bug fixes)
    ← hotfix/* (urgent fixes)
```

### Version Tagging
```bash
# Major release (breaking changes)
git tag -a v2.0.0 -m "Major update with breaking changes"

# Minor release (new features)
git tag -a v1.1.0 -m "Added wishlist feature"

# Patch release (bug fixes)
git tag -a v1.0.1 -m "Fixed cart calculation bug"
```

### Commit Message Format
```
type(scope): subject

feat(cart): add quantity validation
fix(database): resolve null pointer exception
docs(readme): update installation steps
ci(workflows): add iOS build job
```

---

## 🐛 Troubleshooting

### Build Fails on GitHub Actions

**Check:**
1. Dependencies are properly locked (`pubspec.lock` committed)
2. No local file references in code
3. Flutter version matches
4. All tests pass locally

**View Logs:**
1. Go to Actions tab
2. Click failed workflow
3. Expand failed job
4. Review error messages

### Artifacts Not Uploading

**Common Issues:**
- Path is incorrect in workflow
- Build didn't complete successfully
- File size exceeds GitHub limits (2GB)

**Solution:**
Check build output path:
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Release Creation Fails

**Requirements:**
- Must have write permissions
- Tag must follow `v*.*.*` pattern
- Build must succeed
- `GITHUB_TOKEN` must be available (automatic)

---

## 📚 Learn More

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD Guide](https://flutter.dev/docs/deployment/cd)
- [subosito/flutter-action](https://github.com/subosito/flutter-action)

---

## 🎉 What's Automated Now?

✅ **Automatic testing** on every push  
✅ **Automatic APK builds** for every commit  
✅ **Release creation** with one command  
✅ **Code quality checks** on PRs  
✅ **Dependency updates** via Dependabot  
✅ **Artifact storage** for 30-90 days  
✅ **Professional issue/PR templates**  

---

## 🚀 Next Steps

1. **Push to GitHub** to trigger first workflow
2. **Create v1.0.0 tag** for first release
3. **Monitor Actions tab** to see builds
4. **Download artifacts** from completed workflows
5. **Share APKs** with testers

**Your CI/CD is ready to go! Push your code and watch the magic happen! ✨**
