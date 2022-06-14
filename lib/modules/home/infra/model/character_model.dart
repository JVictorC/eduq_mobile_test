
import 'package:eduq_flutter_mobile_test/modules/home/domain/entities/character_entity.dart';

class CharacterModel extends CharacterEntity {
  CharacterModel({
    String? name,
    String? imageUrl,
  }) : super(name: name, imageUrl: imageUrl);


  factory CharacterModel.fromMap(Map<String, dynamic> map) {
    return CharacterModel(
      name: map['name'],
      imageUrl: map['image'],
    );
  }

}
