import 'package:eduq_flutter_mobile_test/core/result.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/failures/home_failures.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/usecases/get_character_by_name_status_usecase.dart';
import 'package:eduq_flutter_mobile_test/modules/home/presenter/providers/home_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/list_character_mock.dart';

class GetCharacterByNameStatusUseCaseMock extends Mock
    implements IGetCharacterByNameStatusUseCase {}

void main() {
  final getCharacterByNameStatusUseCaseMock =
      GetCharacterByNameStatusUseCaseMock();

  final homeProvider = HomeProvider(
    getCharacterByNameStatusUseCase: getCharacterByNameStatusUseCaseMock,
  );

  group(
    'HomeProvider',
    () {
      group(
        'clearProvider',
        () {
          test(
            'Should clear data in Provider',
            () {
              homeProvider.allLoaded = true;
              homeProvider.hasError = true;
              homeProvider.allCharacter = listCharacterMock;
              homeProvider.error = HomeUnknownFailure('Teste');

              expect(homeProvider.allLoaded, true);
              expect(homeProvider.hasError, true);
              expect(homeProvider.allCharacter, listCharacterMock);
              expect(homeProvider.error, isA<HomeUnknownFailure>());

              homeProvider.clearProvider();

              expect(homeProvider.allLoaded, false);
              expect(homeProvider.hasError, false);
              expect(homeProvider.allCharacter, []);
              expect(homeProvider.error, null);
            },
          );
        },
      );

      group(
        'getCharacter',
        () {
          test(
            'Should loading a list of character when useCase return a Success value and not loading all data yet',
            () async {
              when(
                () => getCharacterByNameStatusUseCaseMock(any(), any(), any()),
              ).thenAnswer(
                (invocation) async => Result.success(listCharacterMock),
              );

              expect(homeProvider.allCharacter, []);

              await homeProvider.getCharacter('Morty', 'Live', 1);

              expect(homeProvider.allCharacter, listCharacterMock);
            },
          );

          test(
            'Should loading a list of character and change allLoaded value for true, when useCase return a Array empty',
            () async {
              when(
                () => getCharacterByNameStatusUseCaseMock(any(), any(), any()),
              ).thenAnswer(
                (invocation) async => const Result.success([]),
              );

              homeProvider.clearProvider();

              expect(homeProvider.allLoaded, false);
              expect(homeProvider.allCharacter, []);

              await homeProvider.getCharacter('Morty', 'Live', 1);

              expect(homeProvider.allLoaded, true);
            },
          );

          test(
            'Should change hasError value for true and set error in Error when useCase returns a Error value',
            () async {
              when(
                () => getCharacterByNameStatusUseCaseMock(any(), any(), any()),
              ).thenAnswer(
                (invocation) async => Result.failure(
                  HomeUnknownFailure('Erro para teste'),
                ),
              );

              homeProvider.clearProvider();

              expect(homeProvider.error, null);
              expect(homeProvider.hasError, false);

              await homeProvider.getCharacter('Morty', 'Live', 1);


              expect(homeProvider.error, isA<HomeFailure>());
              expect(homeProvider.hasError, true);

            },
          );
        },
      );
    },
  );
}
