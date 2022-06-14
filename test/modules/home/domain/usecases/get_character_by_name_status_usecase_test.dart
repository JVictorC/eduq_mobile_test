import 'package:eduq_flutter_mobile_test/core/result.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/failures/home_failures.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/repositories/get_character_by_name_status_interface_repository.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/usecases/get_character_by_name_status_usecase.dart';
import 'package:eduq_flutter_mobile_test/modules/home/infra/model/character_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/list_character_mock.dart';

class GetCharacterByNameStatusRepositoryMock extends Mock implements IGetCharacterByNameStatusRepository {}

void main() {
  final getCharacterByNameStatusRepositoryMock = GetCharacterByNameStatusRepositoryMock();
  final getCharacterByNameStatusUseCase = GetCharacterByNameStatusUseCase(
    getCharacterByNameStatusRepository: getCharacterByNameStatusRepositoryMock
  );

  group(
    'GetCharacterByNameStatusUseCase',
    () {
      test(
        'Should be return a instance of Result',
        () async {
          when(() => getCharacterByNameStatusRepositoryMock(any(), any(), any()))
          .thenAnswer((invocation) async => Result.success(listCharacterMock));

          final response = await getCharacterByNameStatusUseCase('Morty', 'Live', 1);

          verify(() =>getCharacterByNameStatusRepositoryMock(any(), any(), any())).called(1);

          expect(response, isA<Result>());
          expect(response.isError, false);
          expect(response.isSuccess, true);
        },
      );

       test(
        'Should be return a List of CharacterModel when repository return a Success value',
        () async {
          when(() => getCharacterByNameStatusRepositoryMock(any(), any(), any()))
          .thenAnswer((invocation) async => Result.success(listCharacterMock));

          final response = await getCharacterByNameStatusUseCase('Morty', 'Live', 1);

          verify(() =>getCharacterByNameStatusRepositoryMock(any(), any(), any())).called(1);

          expect(response.value, isA<List<CharacterModel>>());
          expect(response.value, listCharacterMock);
          expect(response.isSuccess, true);
        },
      );

      test(
        'Should be return a instance of HomeFailure when repository return a Error value',
        () async {
          when(() => getCharacterByNameStatusRepositoryMock(any(), any(), any()))
          .thenAnswer((invocation) async => Result.failure(HomeUnknownFailure('Erro de Teste')));

          final response = await getCharacterByNameStatusUseCase('Morty', 'Live', 1);

          verify(() =>getCharacterByNameStatusRepositoryMock(any(), any(), any())).called(1);

          expect(response.error, isA<HomeFailure>());
          expect(response.error!.message, 'Erro de Teste');
          expect(response.isError, true);
        },
      );

    },
  );
}
