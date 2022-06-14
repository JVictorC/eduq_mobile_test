import 'package:eduq_flutter_mobile_test/core/http_client.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/entities/character_entity.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/failures/home_failures.dart';
import 'package:eduq_flutter_mobile_test/core/result.dart';
import 'package:eduq_flutter_mobile_test/modules/home/infra/data/get_character_by_name_status_interface_data.dart';
import 'package:eduq_flutter_mobile_test/modules/home/infra/model/character_model.dart';

class GetCharacterByNameStatusData implements IGetCharacterByNameStatusData {
  final IHttpClient _client;

  GetCharacterByNameStatusData({
    required IHttpClient client,
  }) : _client = client;

  @override
  Future<Result<HomeFailure, List<CharacterEntity>>> call(String query) async {
    try {
      final response = await _client.get(query);

      final allCharacters = (response['characters']['results'] as List)
          .map(
            (e) => CharacterModel.fromMap(e),
          )
          .toList();

      return Result.success(allCharacters);
    } catch (e) {
      return Result.failure(HomeUnknownFailure(e.toString()));
    }
  }
}
