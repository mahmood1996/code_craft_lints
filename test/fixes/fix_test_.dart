import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart' show SourceEdit;
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:test/test.dart';

abstract class FixTest extends AnalysisRuleTest {
  Future<void> assertFix({
    required String original,

    required String expected,

    required ResolvedCorrectionProducer Function({
      required CorrectionProducerContext context,
    })
    producerFactory,

    int? diagnosticIndex,
  }) async {
    newFile(testFile.path, original);
    result = await resolveFile(testFile.path);

    final diagnostics = result.diagnostics
        .where((d) => d.diagnosticCode.lowerCaseName == rule.name)
        .toList();

    Diagnostic? diagnostic;
    if (diagnostics.isNotEmpty) {
      diagnostic = diagnostics[diagnosticIndex ?? 0];
    }

    final libraryResult =
        await result.session.getResolvedLibraryByElement(result.libraryElement)
            as ResolvedLibraryResult;

    final context = CorrectionProducerContext.createResolved(
      libraryResult: libraryResult,
      unitResult: result,
      diagnostic: diagnostic,
      selectionOffset: diagnostic?.offset ?? 0,
      selectionLength: diagnostic?.length ?? 0,
    );

    final producer = producerFactory(context: context);
    final builder = ChangeBuilder(session: result.session);
    await producer.compute(builder);

    final fileEdit = builder.sourceChange.getFileEdit(testFile.path);
    final edits = fileEdit?.edits ?? [];
    final actual = SourceEdit.applySequence(original, edits);

    expect(actual, expected);
  }
}
