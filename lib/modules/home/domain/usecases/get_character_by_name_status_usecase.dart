import 'package:eduq_flutter_mobile_test/core/result.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/entities/character_entity.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/failures/home_failures.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/repositories/get_character_by_name_status_interface_repository.dart';

abstract class IGetCharacterByNameStatusUseCase {
  Future<Result<HomeFailure, List<CharacterEntity>>> call(String name, String status, int page);
}

class GetCharacterByNameStatusUseCase implements IGetCharacterByNameStatusUseCase {
  final IGetCharacterByNameStatusRepository _getCharacterByNameStatusRepository;

  GetCharacterByNameStatusUseCase(
    {required IGetCharacterByNameStatusRepository getCharacterByNameStatusRepository}
  ) : _getCharacterByNameStatusRepository = getCharacterByNameStatusRepository;

  @override
  Future<Result<HomeFailure, List<CharacterEntity>>> call(String name, String status, int page) async => await _getCharacterByNameStatusRepository(name, status, page);
}
