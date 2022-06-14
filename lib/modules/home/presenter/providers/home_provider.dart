import 'package:eduq_flutter_mobile_test/modules/home/domain/failures/home_failures.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/usecases/get_character_by_name_status_usecase.dart';
import 'package:eduq_flutter_mobile_test/modules/home/infra/model/character_model.dart';
import 'package:flutter/cupertino.dart';

class HomeProvider extends ChangeNotifier {
  final IGetCharacterByNameStatusUseCase _getCharacterByNameStatusUseCase;

  List<CharacterModel> allCharacter = [];
  bool allLoaded = false;

  bool hasError = false;

  HomeFailure? error;

  HomeProvider({
    required IGetCharacterByNameStatusUseCase getCharacterByNameStatusUseCase,
  }) : _getCharacterByNameStatusUseCase = getCharacterByNameStatusUseCase;


  clearProvider() {
    allLoaded = false;
    allCharacter = [];
    hasError = false;
    error = null;
    notifyListeners();
  }

  Future<void> getCharacter(String name, String status, int page) async {

    final response = await _getCharacterByNameStatusUseCase(name, status, page);

    if(response.isError) {
      hasError = true;
      error = response.error;
      notifyListeners();

      return;
    }


    if (response.isSuccess) {
      allLoaded = response.value?.isEmpty ?? false;

      if(allLoaded) return;

      allCharacter = [
        ...allCharacter,
        ...(response.value as List<CharacterModel>),
      ];

      notifyListeners();
    }
  }
}
