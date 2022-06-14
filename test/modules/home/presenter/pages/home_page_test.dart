import 'package:eduq_flutter_mobile_test/core/i.dart';
import 'package:eduq_flutter_mobile_test/core/result.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/usecases/get_character_by_name_status_usecase.dart';
import 'package:eduq_flutter_mobile_test/modules/home/presenter/pages/home_page.dart';
import 'package:eduq_flutter_mobile_test/modules/home/presenter/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import '../../../../mocks/list_character_mock.dart';

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeProvider(
              getCharacterByNameStatusUseCase:
                  I.get<IGetCharacterByNameStatusUseCase>()),
        ),
      ],
      child: const MaterialApp(
        home: HomePage(),
      ),
    ),
  );

  await tester.pump();
}

class GetCharacterByNameStatusUseCaseMock extends Mock
    implements IGetCharacterByNameStatusUseCase {}

void main() {
  final getCharacterByNameStatusUseCaseMock =
      GetCharacterByNameStatusUseCaseMock();

  setUpAll(
    () {
      I.registerSingleton<IGetCharacterByNameStatusUseCase>(
        getCharacterByNameStatusUseCaseMock,
      );
    },
  );

  group(
    'HomePage',
    () {
      testWidgets(
        'Should building without exploding',
        (tester) async {
          await mockNetworkImagesFor(() => _createWidget(tester));

          final homePage = find.byType(HomePage);

          expect(homePage, findsOneWidget);
        },
      );

      testWidgets(
        'Should build widget with infos returns by useCase when search a name and status',
        (tester) async {
          when(
            () => getCharacterByNameStatusUseCaseMock(any(), any(), any()),
          ).thenAnswer((invocation) async => Result.success(listCharacterMock));

          mockNetworkImagesFor(() async {
            await _createWidget(tester);

            final textFormFieldName =
                find.byKey(const Key('text_form_field_name'));
            final textFormFieldStatus =
                find.byKey(const Key('text_form_field_status'));
            final buttonSubmitted = find.byType(ElevatedButton);

            expect(textFormFieldName, findsOneWidget);
            expect(textFormFieldStatus, findsOneWidget);
            expect(buttonSubmitted, findsOneWidget);

            await tester.enterText(textFormFieldName, 'Morty');
            await tester.enterText(textFormFieldStatus, 'Live');

            await tester.tap(buttonSubmitted);

            await tester.pump();

            expect(
              find.byKey(const Key('widget_character_info')),
              findsNWidgets(5),
            );
          });
        },
      );
    },
  );
}
