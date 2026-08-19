import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:code_craft_lints/src/rules/max_two_level_of_indentation.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MaxTwoLevelOfIndentationTest);
  });
}

@reflectiveTest
final class MaxTwoLevelOfIndentationTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = MaxTwoLevelOfIndentationLint();
    super.setUp();
  }

  Future<void> test_singleLevelControlFlow_noLint() async {
    await assertNoDiagnostics(r'''
void f(bool c) {
  if (c) {
    print(1);
  }
  for (var i in []) {
    print(i);
  }
  while (c) {
    print(1);
  }
  switch (1) {
    case 1:
      print(1);
  }
}
''');
  }

  Future<void> test_elseIfChain_noIndentationLint() async {
    await assertNoDiagnostics(r'''
void f(bool a, bool b) {
  if (a) {
    print(1);
  } else if (b) {
    print(2);
  } else {
    print(3);
  }
}
''');
  }

  Future<void> test_nestedIfInsideIf_reportsIndentationLint() async {
    await assertDiagnostics(
      r'''
void f(bool c) {
  if (c) {
    print(1);
    if (c) {
      print(2);
    }
  }
}
''',
      [lint(46, 30)],
    );
  }

  Future<void> test_nestedFor_reportsIndentationLint() async {
    await assertDiagnostics(
      r'''
void f(List<List<int>> list) {
  for (var a in list) {
    for (var b in a) {
      print(b);
    }
  }
}
''',
      [lint(59, 40)],
    );
  }

  Future<void> test_nestedWhileInsideIf_reportsIndentationLint() async {
    await assertDiagnostics(
      r'''
void f(bool c) {
  if (c) {
    while (c) {
      print(1);
    }
  }
}
''',
      [lint(32, 33)],
    );
  }

  Future<void> test_nestedDoWhileInsideIf_reportsIndentationLint() async {
    await assertDiagnostics(
      r'''
void f(bool c) {
  if (c) {
    do {
      print(1);
    } while (c);
  }
}
''',
      [lint(32, 37)],
    );
  }

  Future<void> test_nestedIfInsideSwitch_reportsIndentationLint() async {
    await assertDiagnostics(
      r'''
void f(int x) {
  switch (x) {
    case 1:
      if (x > 0) print(1);
  }
}
''',
      [lint(49, 20)],
    );
  }

  Future<void> test_nestedIfInsideElse_reportsIndentationLint() async {
    await assertDiagnostics(
      r'''
void f(bool c) {
  if (c) {
    print(1);
  } else {
    if (c) print(2);
  }
}
''',
      [lint(57, 16)],
    );
  }

  Future<void> test_nestedIfInsideTry_reportsIndentationLint() async {
    await assertDiagnostics(
      r'''
void f(bool c) {
  try {
    if (c) print(1);
  } catch (e) {
    print(2);
  }
}
''',
      [lint(29, 16)],
    );
  }

  Future<void> test_closureResetsIndentation_noLint() async {
    await assertNoDiagnostics(r'''
void f(bool c) {
  [1, 2].forEach((e) {
    if (c) print(e);
  });
}
''');
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
}
