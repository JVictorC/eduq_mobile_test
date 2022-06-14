import 'package:eduq_flutter_mobile_test/core/i.dart';
import 'package:eduq_flutter_mobile_test/core/init_dependecies.dart';
import 'package:eduq_flutter_mobile_test/modules/home/domain/usecases/get_character_by_name_status_usecase.dart';
import 'package:eduq_flutter_mobile_test/modules/home/presenter/pages/home_page.dart';
import 'package:eduq_flutter_mobile_test/modules/home/presenter/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  initAllDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeProvider(
            getCharacterByNameStatusUseCase:
                I.get<IGetCharacterByNameStatusUseCase>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
