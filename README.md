# code_craft_lints

[![pub package](https://img.shields.io/pub/v/code_craft_lints.svg?logo=dart&color=blue)](https://pub.dev/packages/code_craft_lints)
[![Dart SDK](https://img.shields.io/badge/Dart-%3E%3D3.10.0-blue.svg?logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

A high-performance **Dart Analysis Server Plugin** providing strict architectural rules, cyclomatic complexity reduction, and automated quick fixes for Dart and Flutter codebases.

Built directly on the modern official `analysis_server_plugin` framework, `code_craft_lints` integrates seamlessly with your IDE (VS Code, Android Studio, IntelliJ) and CI/CD pipelines via standard `dart analyze` and `dart fix`.

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Automatic Fixing](#automatic-fixing)
- [Rules & Fixes Catalog](#rules--fixes-catalog)
  - [prefer_ternary](#prefer_ternary)
  - [pure_contract_class](#pure_contract_class)
  - [final_implementation_class](#final_implementation_class)
  - [max_two_level_of_indentation](#max_two_level_of_indentation)
  - [one_statement_per_block](#one_statement_per_block)
- [Disabling Rules](#disabling-rules)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- ⚡ **Official Analyzer Plugin**: Built using Dart's native `analysis_server_plugin` for fast, real-time feedback without extra background processes.
- 🛠️ **Automated Quick Fixes**: Fix issues instantly in your editor (`Alt+Enter` / `Cmd+.`) or across your entire repository with `dart fix --apply`.
- 📐 **Clean Architecture & Object Calisthenics**: Enforces single-statement blocks, flat indentation, and strict class modifier hierarchies.
- 🧪 **100% Tested**: Every rule, AST edge case, and fix producer is rigorously tested.

---

## Installation

Add `code_craft_lints` to your `pubspec.yaml` under `dev_dependencies`:

```yaml
dev_dependencies:
  code_craft_lints: ^1.1.0
```

Then install the dependencies:

```bash
dart pub get
# or for Flutter projects
flutter pub get
```

---

## Configuration

Enable the plugin in your project's `analysis_options.yaml`:

```yaml
plugins:
  code_craft_lints:
```

Once enabled, restart your IDE's Dart Analysis Server or run:

```bash
dart analyze
```

---

## Automatic Fixing

Many rules provided by `code_craft_lints` include automated quick fixes.

### In your IDE
Press `Alt + Enter` (Windows/Linux) or `Cmd + .` (macOS) on any highlighted warning to preview and apply the fix.

### Across your entire project
Apply all available automated fixes in one command:

```bash
dart fix --apply
```

---

## Rules & Fixes Catalog

| Rule | Severity | Automated Fix | Description |
| :--- | :---: | :---: | :--- |
| [`prefer_ternary`](#prefer_ternary) | `Warning` | ✅ Yes | Prefer ternary operators for simple returns and assignments. |
| [`pure_contract_class`](#pure_contract_class) | `Warning` | ✅ Yes | Declare pure contract classes as `abstract interface class`. |
| [`final_implementation_class`](#final_implementation_class) | `Warning` | ✅ Yes | Declare concrete implementation classes as `final class` or `base class`. |
| [`max_two_level_of_indentation`](#max_two_level_of_indentation) | `Warning` | ❌ Manual | Enforce at most 2 levels of indentation per function. |
| [`one_statement_per_block`](#one_statement_per_block) | `Warning` | ❌ Manual | Ensure control blocks contain at most one statement. |

---

### `prefer_ternary`

**Severity:** `Warning`  
**Diagnostic Code:** `prefer_ternary`  
**Automated Fix:** `Convert to ternary operator`

#### Rationale
Using multi-line `if/else` statements solely to return different values or assign to the same variable creates unnecessary boilerplate and increases cognitive load. Modern Dart concise expressions improve readability and reduce nesting.

#### Return Statements

##### ❌ Bad
```dart
String formatStatus(bool isActive) {
  if (isActive) {
    return 'Active';
  } else {
    return 'Inactive';
  }
}
```

##### ✅ Good
```dart
String formatStatus(bool isActive) {
  return isActive ? 'Active' : 'Inactive';
}
```

#### Assignment Statements

##### ❌ Bad
```dart
void updateStatus(bool isActive) {
  String status;
  if (isActive) {
    status = 'Active';
  } else {
    status = 'Inactive';
  }
}
```

##### ✅ Good
```dart
void updateStatus(bool isActive) {
  String status;
  status = isActive ? 'Active' : 'Inactive';
}
```

---

### `pure_contract_class`

**Severity:** `Warning`  
**Diagnostic Code:** `pure_contract_class`  
**Automated Fix:** `Add 'interface' modifier`

#### Rationale
In Dart 3+, `abstract class` allows both interface implementation (`implements`) and subclassing (`extends`). If an abstract class contains **no concrete method implementations** and **no instance fields**, it represents a pure contract and should be explicitly declared as `abstract interface class` to prevent unintended code reuse and define a strict API boundary.

##### ❌ Bad
```dart
abstract class UserRepository {
  Future<User> findById(String id);
  Future<void> save(User user);
}
```

##### ✅ Good
```dart
abstract interface class UserRepository {
  Future<User> findById(String id);
  Future<void> save(User user);
}
```

---

### `final_implementation_class`

**Severity:** `Warning`  
**Diagnostic Code:** `final_implementation_class`  
**Automated Fixes:**
- `Add 'final' modifier` (Recommended)
- `Add 'base' modifier`

#### Rationale
Concrete classes without class modifiers are open for subclassing, implementation, and mixing outside their defining library. This can lead to fragile base class problems and broken encapsulation. Concrete classes should be declared `final class` (or `base class` if inheritance across libraries is explicitly intended).

##### ❌ Bad
```dart
class Authenticator {
  void authenticate() {
    // Concrete implementation
  }
}
```

##### ✅ Good
```dart
final class Authenticator {
  void authenticate() {
    // Concrete implementation
  }
}
```

Or, if subclassing is explicitly supported:

```dart
base class Authenticator {
  void authenticate() {
    // Concrete implementation
  }
}
```

---

### `max_two_level_of_indentation`

**Severity:** `Warning`  
**Diagnostic Code:** `max_two_level_of_indentation`  
**Automated Fix:** Manual refactoring / helper extraction

#### Rationale
Rooted in **Object Calisthenics**, this rule mandates that a single function body should not exceed 2 levels of indentation (Level 0: function declaration, Level 1: function body, Level 2: first-level control flow block, Level 3+: nested control flow violation). Deeply nested control flow ("arrowhead anti-pattern") makes functions difficult to reason about, test, and maintain.

##### ❌ Bad
```dart
void processOrders(List<Order> orders) {
  for (final order in orders) {
    if (order.isValid) { // ⚠️ Level 3 (nested control flow inside for-loop)!
      ship(order);
    }
  }
}
```

##### ✅ Good
```dart
void processOrders(List<Order> orders) {
  for (final order in orders) {
    _processSingleOrder(order);
  }
}

void _processSingleOrder(Order order) {
  if (order.isValid) {
    ship(order);
  }
}
```

---

### `one_statement_per_block`

**Severity:** `Warning`  
**Diagnostic Code:** `one_statement_per_block`  
**Automated Fix:** Manual refactoring / helper extraction

#### Rationale
Encourages small, single-responsibility blocks. Any block within a control structure (`if`, `for`, `while`, `try`, `catch`, `finally`) should contain at most one statement. If a branch requires multiple operations, extract that sequence into a well-named helper method.

##### ❌ Bad
```dart
void handleResponse(Response response) {
  if (response.isSuccess) {
    logResponse(response); // ⚠️ Block contains 2 statements
    updateUi(response.body);
  }
}
```

##### ✅ Good
```dart
void handleResponse(Response response) {
  if (response.isSuccess) {
    _onSuccess(response);
  }
}

void _onSuccess(Response response) {
  logResponse(response);
  updateUi(response.body);
}
```

---

## Disabling Rules

### Ignore a rule for a specific line
Add an `// ignore:` comment above the line:

```dart
// ignore: prefer_ternary
if (isReady) {
  return true;
} else {
  return false;
}
```

### Ignore a rule for an entire file
Add an `// ignore_for_file:` comment at the very top of the file:

```dart
// ignore_for_file: pure_contract_class
```

---

## Contributing

We welcome contributions! Please review [CONTRIBUTING.md](CONTRIBUTING.md) before submitting a pull request.

> ⚠️ **Strict Quality Guideline**: In this repository, **every single line of code and branch must be backed by comprehensive unit tests**.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
