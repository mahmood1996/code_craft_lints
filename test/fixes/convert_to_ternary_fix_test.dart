import 'package:custom_lints/src/fixes/convert_to_ternary_fix.dart';
import 'package:custom_lints/src/rules/prefer_ternary.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'fix_test_.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(ConvertToTernaryFixTest);
  });
}

@reflectiveTest
final class ConvertToTernaryFixTest extends FixTest {
  @override
  void setUp() {
    rule = PreferTernaryLint();
    super.setUp();
  }

  Future<void> test_returnWithBlocks() async {
    await assertFix(
      original: r'''
int foo(bool cond) {
  if (cond) {
    return 1;
  } else {
    return 2;
  }
}
''',
      expected: r'''
int foo(bool cond) {
  return cond ? 1 : 2;
}
''',
      producerFactory: ConvertToTernaryFix.new,
    );
  }

  Future<void> test_returnWithoutBlocks() async {
    await assertFix(
      original: r'''
int foo(bool cond) {
  if (cond)
    return 1;
  else
    return 2;
}
''',
      expected: r'''
int foo(bool cond) {
  return cond ? 1 : 2;
}
''',
      producerFactory: ConvertToTernaryFix.new,
    );
  }

  Future<void> test_assignmentWithBlocks() async {
    await assertFix(
      original: r'''
void foo(bool cond) {
  int x;
  if (cond) {
    x = 1;
  } else {
    x = 2;
  }
}
''',
      expected: r'''
void foo(bool cond) {
  int x;
  x = cond ? 1 : 2;
}
''',
      producerFactory: ConvertToTernaryFix.new,
    );
  }

  Future<void> test_assignmentWithoutBlocks() async {
    await assertFix(
      original: r'''
void foo(bool cond) {
  int x;
  if (cond)
    x = 1;
  else
    x = 2;
}
''',
      expected: r'''
void foo(bool cond) {
  int x;
  x = cond ? 1 : 2;
}
''',
      producerFactory: ConvertToTernaryFix.new,
    );
  }
}
