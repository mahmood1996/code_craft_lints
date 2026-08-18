import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:code_craft_lints/src/rules/one_statement_per_block.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(OneStatementPerBlockTest);
  });
}

@reflectiveTest
class OneStatementPerBlockTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = OneStatementPerBlockLint();
    super.setUp();
  }

  Future<void> test_singleStatementIf_noLint() async {
    await assertNoDiagnostics(r'''
void f(bool c) {
  if (c) {
    print(1);
  }
}
''');
  }

  Future<void> test_multiStatementIf_reportsLint() async {
    await assertDiagnostics(
      r'''
void f(bool c) {
  if (c) {
    print(1);
    print(2);
  }
}
''',
      [lint(26, 33)],
    );
  }

  Future<void> test_singleStatementElse_noLint() async {
    await assertNoDiagnostics(r'''
void f(bool c) {
  if (c) {
    print(1);
  } else {
    print(2);
  }
}
''');
  }

  Future<void> test_multiStatementElse_reportsLint() async {
    await assertDiagnostics(
      r'''
void f(bool c) {
  if (c) {
    print(1);
  } else {
    print(2);
    print(3);
  }
}
''',
      [lint(51, 33)],
    );
  }

  Future<void> test_elseIfChain_multiStatementInElseIf_reportsLint() async {
    await assertDiagnostics(
      r'''
void f(int c) {
  if (c == 1) {
    print(1);
  } else if (c == 2) {
    print(2);
    print(3);
  }
}
''',
      [lint(67, 33)],
    );
  }

  Future<void> test_singleStatementFor_noLint() async {
    await assertNoDiagnostics(r'''
void f() {
  for (var i = 0; i < 10; i++) {
    print(i);
  }
  for (var x in [1, 2]) {
    print(x);
  }
}
''');
  }

  Future<void> test_multiStatementFor_reportsLint() async {
    await assertDiagnostics(
      r'''
void f() {
  for (var i = 0; i < 10; i++) {
    print(i);
    print(i + 1);
  }
}
''',
      [lint(42, 37)],
    );
  }

  Future<void> test_multiStatementForIn_reportsLint() async {
    await assertDiagnostics(
      r'''
void f(List<int> list) {
  for (var x in list) {
    print(x);
    print(x + 1);
  }
}
''',
      [lint(47, 37)],
    );
  }

  Future<void> test_singleStatementWhile_noLint() async {
    await assertNoDiagnostics(r'''
void f(bool c) {
  while (c) {
    print(1);
  }
}
''');
  }

  Future<void> test_multiStatementWhile_reportsLint() async {
    await assertDiagnostics(
      r'''
void f(bool c) {
  while (c) {
    print(1);
    print(2);
  }
}
''',
      [lint(29, 33)],
    );
  }

  Future<void> test_singleStatementDoWhile_noLint() async {
    await assertNoDiagnostics(r'''
void f(bool c) {
  do {
    print(1);
  } while (c);
}
''');
  }

  Future<void> test_multiStatementDoWhile_reportsLint() async {
    await assertDiagnostics(
      r'''
void f(bool c) {
  do {
    print(1);
    print(2);
  } while (c);
}
''',
      [lint(22, 33)],
    );
  }

  Future<void> test_tryCatchFinallySingleStatement_noLint() async {
    await assertNoDiagnostics(r'''
void f() {
  try {
    print(1);
  } catch (e) {
    print(2);
  } finally {
    print(3);
  }
}
''');
  }

  Future<void> test_tryMultiStatement_reportsLint() async {
    await assertDiagnostics(
      r'''
void f() {
  try {
    print(1);
    print(2);
  } catch (e) {
    print(3);
  }
}
''',
      [lint(17, 33)],
    );
  }

  Future<void> test_catchMultiStatement_reportsLint() async {
    await assertDiagnostics(
      r'''
void f() {
  try {
    print(1);
  } catch (e) {
    print(2);
    print(3);
  }
}
''',
      [lint(47, 33)],
    );
  }

  Future<void> test_finallyMultiStatement_reportsLint() async {
    await assertDiagnostics(
      r'''
void f() {
  try {
    print(1);
  } catch (e) {
    print(2);
  } finally {
    print(3);
    print(4);
  }
}
''',
      [lint(75, 33)],
    );
  }

  Future<void> test_nonBlockStatements_noLint() async {
    await assertNoDiagnostics(r'''
void f(bool c) {
  if (c) print(1);
  for (var i = 0; i < 10; i++) print(i);
  while (c) print(1);
}
''');
  }

  Future<void> test_emptyBlock_noLint() async {
    await assertNoDiagnostics(r'''
void f(bool c) {
  if (c) {}
  try {} catch (e) {} finally {}
}
''');
  }
}
