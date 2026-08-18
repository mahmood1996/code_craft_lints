import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:custom_lints/src/rules/prefer_ternary.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PreferTernaryTest);
  });
}

@reflectiveTest
class PreferTernaryTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = PreferTernaryLint();
    super.setUp();
  }

  Future<void> test_ifElseReturn_withBlocks_reportsLint() async {
    await assertDiagnostics(
      r'''
int f(bool c) {
  if (c) {
    return 1;
  } else {
    return 2;
  }
}
''',
      [lint(18, 51)],
    );
  }

  Future<void> test_ifElseReturn_withoutBlocks_reportsLint() async {
    await assertDiagnostics(
      r'''
int f(bool c) {
  if (c) return 1; else return 2;
}
''',
      [lint(18, 31)],
    );
  }

  Future<void> test_ifElseAssignment_sameVariable_reportsLint() async {
    await assertDiagnostics(
      r'''
void f(bool c) {
  int x;
  if (c) {
    x = 1;
  } else {
    x = 2;
  }
}
''',
      [lint(28, 45)],
    );
  }

  Future<void> test_ifElseAssignment_differentVariables_noLint() async {
    await assertNoDiagnostics(r'''
void f(bool c) {
  int x = 0;
  int y = 0;
  if (c) {
    x = 1;
  } else {
    y = 2;
  }
}
''');
  }

  Future<void> test_ifWithoutElse_noLint() async {
    await assertNoDiagnostics(r'''
int f(bool c) {
  if (c) {
    return 1;
  }
  return 2;
}
''');
  }

  Future<void> test_ifElseMultipleStatements_noLint() async {
    await assertNoDiagnostics(r'''
int f(bool c) {
  if (c) {
    print('hello');
    return 1;
  } else {
    return 2;
  }
}
''');
  }

  Future<void> test_ifElseIf_withoutTrailingElse_noLint() async {
    await assertNoDiagnostics(r'''
int f(int c) {
  if (c == 1) {
    return 1;
  } else if (c == 2) {
    return 2;
  }
  return 3;
}
''');
  }

  Future<void> test_ifElseIf_withTrailingElse_reportsOnInnerIf() async {
    await assertDiagnostics(
      r'''
int f(int c) {
  if (c == 1) {
    return 1;
  } else if (c == 2) {
    return 2;
  } else {
    return 3;
  }
}
''',
      [lint(54, 56)],
    );
  }
}
