import 'package:code_craft_lints/src/fixes/make_class_interface_fix.dart';
import 'package:code_craft_lints/src/rules/pure_contract_class.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'fix_test_.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MakeClassInterfaceFixTest);
  });
}

@reflectiveTest
final class MakeClassInterfaceFixTest extends FixTest {
  @override
  void setUp() {
    rule = PureContractClassLint();
    super.setUp();
  }

  Future<void> test_makeClassInterface() async {
    await assertFix(
      original: r'''
abstract class C {
  void foo();
}
''',
      expected: r'''
abstract interface class C {
  void foo();
}
''',
      producerFactory: MakeClassInterfaceFix.new,
    );
  }

  Future<void> test_makeClassInterface_withStaticMembers() async {
    await assertFix(
      original: r'''
abstract class C {
  static const int x = 1;
  void foo();
}
''',
      expected: r'''
abstract interface class C {
  static const int x = 1;
  void foo();
}
''',
      producerFactory: MakeClassInterfaceFix.new,
    );
  }
}
