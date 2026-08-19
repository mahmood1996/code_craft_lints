/// Example application demonstrating code written in compliance with
/// all `code_craft_lints` rules and automated fix conventions.
library example;

// ============================================================================
// 1. Rule: pure_contract_class
// Enforces pure interface contracts to use `abstract interface class`.
// ============================================================================

/// Contract defining repository operations for user accounts.
///
/// In Dart 3+, pure contracts without method bodies or instance state
/// should use `abstract interface class`.
abstract interface class UserRepository {
  /// Finds a user name by their unique [id].
  Future<String?> findById(String id);

  /// Saves a new user record with [id] and [name].
  Future<void> save(String id, String name);
}

// ============================================================================
// 2. Rule: final_implementation_class
// Concrete implementation classes should be declared `final class` (or `base`).
// ============================================================================

/// In-memory implementation of [UserRepository].
///
/// Marked as `final class` to prevent accidental inheritance and preserve
/// encapsulation boundaries.
final class InMemoryUserRepository implements UserRepository {
  final Map<String, String> _storage = <String, String>{};

  @override
  Future<String?> findById(String id) async {
    return _storage[id];
  }

  @override
  Future<void> save(String id, String name) async {
    _storage[id] = name;
  }
}

// ============================================================================
// 3. Rule: prefer_ternary
// Prefer concise ternary expressions for simple conditional returns/assignments.
// ============================================================================

/// Formats the account status into a human-readable label.
String formatAccountStatus({required bool isActive}) {
  // Uses ternary operator instead of verbose if-else return blocks
  return isActive ? 'Active Account' : 'Inactive Account';
}

// ============================================================================
// 4. Rule: max_two_level_of_indentation & one_statement_per_block
// Enforces flat control flow and single-responsibility blocks.
// ============================================================================

/// Service orchestrating user notifications.
final class NotificationService {
  /// Dispatches greetings to all registered user IDs.
  ///
  /// Notice that the loop delegates processing to a dedicated helper method,
  /// keeping the indentation level <= 2 and block statements <= 1.
  Future<void> notifyUsers(
    List<String> userIds,
    UserRepository repository,
  ) async {
    for (final id in userIds) {
      await _notifySingleUser(id, repository);
    }
  }

  Future<void> _notifySingleUser(String id, UserRepository repository) async {
    final name = await repository.findById(id);
    if (name != null) {
      _sendGreeting(name);
    }
  }

  void _sendGreeting(String name) {
    // In a real app, this would send an email or push notification.
    // ignore: avoid_print
    print('Sending notification to: $name');
  }
}

/// Entry point demonstrating the example workflow.
Future<void> main() async {
  // ignore: avoid_print
  print('--- code_craft_lints Example Demonstration ---');

  // Initialize repository and service
  final repository = InMemoryUserRepository();
  final notificationService = NotificationService();

  // Save sample users
  await repository.save('u1', 'Alice');
  await repository.save('u2', 'Bob');

  // Demonstrate ternary status formatting
  // ignore: avoid_print
  print('User u1 status: ${formatAccountStatus(isActive: true)}');
  // ignore: avoid_print
  print('User u2 status: ${formatAccountStatus(isActive: false)}');

  // Dispatch notifications with flat control flow
  await notificationService.notifyUsers(['u1', 'u2', 'u3'], repository);

  // ignore: avoid_print
  print('--- Done! All code satisfies code_craft_lints rules ---');
}
