# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2026-08-19

### Fixed
- Fixed example project to work with the analyzer plugin.

## [1.0.1] - 2026-08-19

### Fixed
- Fixed analyzer plugin path resolution in example project.
- Added comprehensive example project and documentation.

## [1.0.0] - 2026-08-19

### Added
- Initial release of `code_craft_lints` analysis server plugin.
- **Lint Rules**:
  - `prefer_ternary`: Enforces ternary operators for simple single-statement returns and assignments instead of verbose `if`/`else` blocks.
  - `pure_contract_class`: Enforces the `abstract interface class` declaration for pure contract classes without implementations or instance fields.
  - `final_implementation_class`: Enforces `final class` or `base class` modifiers on concrete implementation classes to prevent unintentional inheritance.
  - `one_level_of_indentation`: Enforces Object Calisthenics indentation rule (maximum 1 level of control-flow indentation per function).
  - `one_statement_per_block`: Enforces that control blocks contain at most one statement to promote concise function decomposition.
- **Automated Fixes (`dart fix --apply`)**:
  - `Convert to ternary operator` for `prefer_ternary`.
  - `Add 'interface' modifier` for `pure_contract_class`.
  - `Add 'final' modifier` for `final_implementation_class`.
  - `Add 'base' modifier` for `final_implementation_class`.
