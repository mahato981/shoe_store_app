# Contributing to Shoe Store App

Thank you for your interest in contributing! 🎉

## 📋 Table of Contents
- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)

## 📜 Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on constructive feedback
- Keep discussions professional

## 🤝 How to Contribute

### Reporting Bugs
1. Check if the bug has already been reported
2. Use the bug report template
3. Include detailed steps to reproduce
4. Add screenshots if applicable

### Suggesting Features
1. Check if the feature has already been suggested
2. Use the feature request template
3. Explain the use case and benefits
4. Consider implementation complexity

### Code Contributions
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test thoroughly
5. Commit with clear messages
6. Push to your fork
7. Open a Pull Request

## 🛠️ Development Setup

### Prerequisites
- Flutter SDK 3.24.5 or higher
- Android Studio / VS Code
- Android SDK (for Android builds)
- Git

### Setup Steps
```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/shoe_store_app.git
cd shoe_store_app

# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Run analyzer
flutter analyze
```

## 📝 Coding Standards

### Dart Style Guide
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `dart format` before committing
- Run `flutter analyze` and fix all warnings

### File Organization
```
lib/
├── models/      # Data models
├── providers/   # State management
├── screens/     # UI screens
├── widgets/     # Reusable widgets
├── database/    # Database operations
└── utils/       # Utilities
```

### Naming Conventions
- Classes: `PascalCase` (e.g., `ShoeProvider`)
- Variables/Functions: `camelCase` (e.g., `getShoeById`)
- Constants: `lowerCamelCase` (e.g., `maxCartItems`)
- Files: `snake_case` (e.g., `shoe_detail_screen.dart`)

### Best Practices
- Keep functions small and focused
- Write self-documenting code
- Add comments for complex logic
- Handle errors gracefully
- Use meaningful variable names
- Avoid deep nesting

## 💬 Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements

### Examples
```
feat(cart): add quantity increment/decrement buttons

fix(database): resolve null pointer exception in getShoes

docs(readme): update installation instructions

refactor(providers): simplify state management logic
```

## 🔄 Pull Request Process

### Before Submitting
1. **Update your branch** with the latest main
   ```bash
   git checkout main
   git pull origin main
   git checkout your-feature-branch
   git rebase main
   ```

2. **Run all checks**
   ```bash
   flutter analyze
   flutter test
   dart format .
   ```

3. **Test your changes**
   - Test on multiple devices/emulators
   - Verify existing features still work
   - Add tests for new features

### PR Requirements
- [ ] Code follows the style guidelines
- [ ] All tests pass
- [ ] No new warnings from analyzer
- [ ] Documentation updated (if needed)
- [ ] Screenshots added (for UI changes)
- [ ] PR description is clear and complete

### PR Template
Use the provided PR template and fill in all sections:
- Description of changes
- Type of change
- Testing done
- Screenshots (if applicable)

### Review Process
1. Maintainers will review your PR
2. Address any feedback or requested changes
3. Once approved, your PR will be merged
4. Celebrate! 🎉

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage
```

### Writing Tests
- Write tests for new features
- Update tests for modified features
- Aim for good test coverage
- Test edge cases and error conditions

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Best Practices](https://flutter.dev/docs/development/tools/formatting)

## ❓ Questions?

- Open a [GitHub Discussion](../../discussions)
- Check existing issues and PRs
- Review the documentation

## 🙏 Thank You!

Your contributions make this project better for everyone. We appreciate your time and effort!
