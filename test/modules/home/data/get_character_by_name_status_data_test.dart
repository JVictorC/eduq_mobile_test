



import 'package:eduq_flutter_mobile_test/core/http_client.dart';
import 'package:eduq_flutter_mobile_test/core/result.dart';
import 'package:eduq_flutter_mobile_test/modules/home/data/data/get_character_by_name_status_data.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/failures/home_failures.dart';
import 'package:eduq_flutter_mobile_test/modules/home/infra/model/character_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/list_character_mock.dart';
import '../../../mocks/response_api_mock.dart';
import '../infra/get_character_by_name_status_repository_test.dart';

 class HttpClientMock extends Mock implements IHttpClient {}


void main() {
  final httpClientMock = HttpClientMock();

  final getCharacterByNameStatusData = GetCharacterByNameStatusData(client: httpClientMock,);

    group(
    'GetCharacterByNameStatusData',
    () {

      test(
        'Should be return a instance of Result',
        () async {
          when(() => httpClientMock.get(any()))
          .thenAnswer((invocation) async => responseApiMock);

          final response = await getCharacterByNameStatusData('query');

          verify(() => httpClientMock.get(any())).called(1);

          expect(response, isA<Result>());
          expect(response.isError, false);
          expect(response.isSuccess, true);
        },
      );

       test(
        'Should be return a List of CharacterModel when request return a Success value',
        () async {
           when(() => httpClientMock.get(any()))
          .thenAnswer((invocation) async => responseApiMock);

          final response = await getCharacterByNameStatusData('query');

          verify(() => httpClientMock.get(any())).called(1);

          expect(response.value, isA<List<CharacterModel>>());
          expect(response.value!.length, listCharacterMock.length);
          expect(response.isSuccess, true);
        },
      );

      test(
        'Should be return a instance of HomeUnknownFailure when request return a Error value',
        () async {
           when(() => httpClientMock.get(any()))
          .thenThrow(ErrorTest('Erro Teste'));

          final response = await getCharacterByNameStatusData('query');

          verify(() => httpClientMock.get(any())).called(1);

          expect(response.error, isA<HomeFailure>());
          expect(response.isError, true);
        },
      );

    },
  );
}