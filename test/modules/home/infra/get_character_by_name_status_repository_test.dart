import 'package:eduq_flutter_mobile_test/core/result.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/failures/home_failures.dart';
import 'package:eduq_flutter_mobile_test/modules/home/infra/data/get_character_by_name_status_interface_data.dart';
import 'package:eduq_flutter_mobile_test/modules/home/infra/model/character_model.dart';
import 'package:eduq_flutter_mobile_test/modules/home/infra/repositories/get_character_by_name_status_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/list_character_mock.dart';

class GetCharacterByNameStatusDataMock extends Mock
    implements IGetCharacterByNameStatusData {}

class ErrorTest implements Exception {
  final String? message;

  ErrorTest(this.message);
}

void main() {
  final getCharacterByNameStatusDataMock = GetCharacterByNameStatusDataMock();
  final getCharacterByNameStatusRepository = GetCharacterByNameStatusRepository(
      getCharacterByNameStatusData: getCharacterByNameStatusDataMock);

  group(
    'GetCharacterByNameStatusRepository',
    () {
      test(
        'Should be return a instance of Result',
        () async {
          when(() => getCharacterByNameStatusDataMock(any())).thenAnswer(
              (invocation) async => Result.success(listCharacterMock));

          final response =
              await getCharacterByNameStatusRepository('Morty', 'Live', 1);

          verify(() => getCharacterByNameStatusDataMock(any())).called(1);

          expect(response, isA<Result>());
          expect(response.isError, false);
          expect(response.isSuccess, true);
        },
      );

      test(
        'Should be return a List of CharacterModel when data return a Success value',
        () async {
          when(() => getCharacterByNameStatusDataMock(any())).thenAnswer(
              (invocation) async => Result.success(listCharacterMock));

          final response =
              await getCharacterByNameStatusRepository('Morty', 'Live', 1);

          verify(() => getCharacterByNameStatusDataMock(any())).called(1);

          expect(response.value, isA<List<CharacterModel>>());
          expect(response.value, listCharacterMock);
          expect(response.isSuccess, true);
        },
      );

      test(
        'Should be return a instance of HomeFailure when data return a empty array in page 1',
        () async {
          when(() => getCharacterByNameStatusDataMock(any())).thenAnswer(
            (invocation) async => const Result.success(
              [],
            ),
          );

          final response = await getCharacterByNameStatusRepository('Morty', 'Live', 1);

          verify(() => getCharacterByNameStatusDataMock(any())).called(1);

          expect(response.error, isA<HomeNotFindFailure>());
          expect(response.error!.message, 'Nenhum Dado Encontrado');
          expect(response.isError, true);
        },
      );

      test(
        'Should be return a instance of HomeFailure when data return a Error value',
        () async {
          when(() => getCharacterByNameStatusDataMock(any())).thenAnswer(
            (invocation) async => Result.failure(
              HomeUnknownFailure('Erro de Teste'),
            ),
          );

          final response = await getCharacterByNameStatusRepository('Morty', 'Live', 1);

          verify(() => getCharacterByNameStatusDataMock(any())).called(1);

          expect(response.error, isA<HomeFailure>());
          expect(response.error!.message, 'Erro de Teste');
          expect(response.isError, true);
        },
      );

      test(
        'Should be return a instance of HomeUnknownFailure when data return a Unknown Error value',
        () async {
          when(() => getCharacterByNameStatusDataMock(any()))
              .thenThrow(ErrorTest('Erro Teste'));

          final response =
              await getCharacterByNameStatusRepository('Morty', 'Live', 1);

          expect(response.error, isA<HomeUnknownFailure>());
          expect(response.isError, true);
        },
      );
    },
  );
}
