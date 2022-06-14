import 'package:eduq_flutter_mobile_test/modules/home/infra/model/character_model.dart';

import 'response_api_mock.dart';

final listCharacterMock = (
  responseApiMock['characters']!['results'] as List
  ).map((e) => CharacterModel.fromMap(e)).toList();