import 'package:eduq_flutter_mobile_test/core/result.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/entities/character_entity.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/failures/home_failures.dart';

abstract class IGetCharacterByNameStatusRepository {
  Future<Result<HomeFailure, List<CharacterEntity>>> call(String name, String status, int page);
}