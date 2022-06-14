import 'package:eduq_flutter_mobile_test/modules/home/domain/entities/character_entity.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/failures/home_failures.dart';
import 'package:eduq_flutter_mobile_test/core/result.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/repositories/get_character_by_name_status_interface_repository.dart';
import 'package:eduq_flutter_mobile_test/modules/home/infra/data/get_character_by_name_status_interface_data.dart';

class GetCharacterByNameStatusRepository
    implements IGetCharacterByNameStatusRepository {
  final IGetCharacterByNameStatusData _getCharacterByNameStatusData;

  GetCharacterByNameStatusRepository({
    required IGetCharacterByNameStatusData getCharacterByNameStatusData,
  }) : _getCharacterByNameStatusData = getCharacterByNameStatusData;

  @override
  Future<Result<HomeFailure, List<CharacterEntity>>> call(
      String name, String status, int page) async {
    try {
      final query = """
        query {
          characters( filter: { name: "$name", status: "$status"}, page: $page) {
            results {
              name
              image
            }
          }
        }
    """;

      final response = await _getCharacterByNameStatusData(query);

      if (response.isError) throw response.error!;

      if (page == 1 && response.value!.isEmpty) {
        throw HomeNotFindFailure('Nenhum Dado Encontrado');
      }

      return response;
    } on HomeFailure catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(HomeUnknownFailure(e.toString()));
    }
  }
}
