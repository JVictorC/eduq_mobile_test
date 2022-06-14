import 'package:eduq_flutter_mobile_test/core/I.dart';
import 'package:eduq_flutter_mobile_test/core/http_client.dart';
import 'package:eduq_flutter_mobile_test/modules/home/data/data/get_character_by_name_status_data.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/repositories/get_character_by_name_status_interface_repository.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/usecases/get_character_by_name_status_usecase.dart';
import 'package:eduq_flutter_mobile_test/modules/home/infra/data/get_character_by_name_status_interface_data.dart';
import 'package:eduq_flutter_mobile_test/modules/home/infra/repositories/get_character_by_name_status_repository.dart';

void coreDependencies() {
  I.registerSingleton<IHttpClient>(HttpClient());
}

void homeDependencies() {
  // data
  I.registerSingleton<IGetCharacterByNameStatusData>(
    GetCharacterByNameStatusData(
      client: I.get<IHttpClient>(),
    ),
  );

  // repositories
  I.registerSingleton<IGetCharacterByNameStatusRepository>(
    GetCharacterByNameStatusRepository(
      getCharacterByNameStatusData: I.get<IGetCharacterByNameStatusData>(),
    ),
  );

  // useCases
  I.registerSingleton<IGetCharacterByNameStatusUseCase>(
    GetCharacterByNameStatusUseCase(
      getCharacterByNameStatusRepository: I.get<IGetCharacterByNameStatusRepository >(),
    ),
  );
}

void initAllDependencies() {
  coreDependencies();
  homeDependencies();
}
