# code_craft_lints Example

This directory provides a practical example demonstrating how to configure and use `code_craft_lints` in a Dart or Flutter project.

---

## 🚀 Getting Started

### 1. Add `code_craft_lints` to `pubspec.yaml`

```yaml
dev_dependencies:
  code_craft_lints: ^1.1.0
```

### 2. Configure `analysis_options.yaml`

Enable the plugin under the `plugins` section:

```yaml
include: package:lints/recommended.yaml

plugins:
  code_craft_lints:
```

### 3. Run Analysis

Run `dart analyze` to view warnings reported by `code_craft_lints`:

```bash
dart analyze
```

### 4. Apply Automated Fixes

Apply available quick fixes across your codebase with:

```bash
dart fix --apply
```

---

## 📖 What This Example Demonstrates

The code in [`main.dart`](main.dart) illustrates clean code patterns compliant with all `code_craft_lints` rules:

| Rule | Demonstration in `main.dart` | Automated Fix Available |
| :--- | :--- | :---: |
| **`pure_contract_class`** | `abstract interface class UserRepository` defines an abstract contract without state or method bodies. | ✅ (`Add 'interface' modifier`) |
| **`final_implementation_class`** | `final class InMemoryUserRepository` and `final class NotificationService` prevent unintended subclassing. | ✅ (`Add 'final' modifier`) |
| **`prefer_ternary`** | `formatAccountStatus` uses concise ternary expressions instead of verbose `if-else` blocks. | ✅ (`Convert to ternary operator`) |
| **`max_two_level_of_indentation`** | `notifyUsers` extracts loop logic into `_notifySingleUser` to maintain at most 2 levels of indentation. | ❌ (Manual refactor) |
| **`one_statement_per_block`** | Conditionals and loops contain at most one statement per block. | ❌ (Manual refactor) |

---

## ▶️ Running the Example

Execute the example via the Dart CLI:

```bash
dart run example/main.dart
```
