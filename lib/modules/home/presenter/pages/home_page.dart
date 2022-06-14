import 'package:eduq_flutter_mobile_test/modules/home/presenter/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _textNameController = TextEditingController();
  final _textStatusController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _page = 1;

  bool isLoadingInitialValues = false;
  bool isLoadingMoreValues = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      () async {
        final isAllLoaded =
            Provider.of<HomeProvider>(context, listen: false).allLoaded;

        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent &&
            !isAllLoaded) {
          _page += 1;

          setState(() => isLoadingMoreValues = true);

          await Provider.of<HomeProvider>(context, listen: false).getCharacter(
            _textNameController.text,
            _textStatusController.text,
            _page,
          );

          print(Provider.of<HomeProvider>(context, listen: false).allLoaded);

          setState(() => isLoadingMoreValues = false);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future fetchData() async {
    final validation = _formKey.currentState!.validate();

    if (validation) {
      _page = 1;
      Provider.of<HomeProvider>(context, listen: false).clearProvider();

      await Provider.of<HomeProvider>(context, listen: false).getCharacter(
        _textNameController.text,
        _textStatusController.text,
        _page,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      key: const Key('text_form_field_name'),
                      controller: _textNameController,
                      decoration: const InputDecoration(hintText: 'Nome'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'O campo Nao pode ser Vazio';
                        }
                      },
                    ),
                    TextFormField(
                      key: const Key('text_form_field_status'),
                      controller: _textStatusController,
                      decoration: const InputDecoration(hintText: 'Status'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'O campo Nao pode ser Vazio';
                        }
                      },
                    ),
                  ],
                ),
              ),
              homeProvider.hasError
                  ? Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            homeProvider.error!.message!,
                            style: const TextStyle(fontSize: 25),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          const Icon(
                            Icons.error_outline,
                            size: 45,
                          )
                        ],
                      ),
                    )
                  : isLoadingInitialValues
                      ? const Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Stack(
                                children: [
                                  ListView.builder(
                                    key: const Key('list_of_character'),
                                    controller: _scrollController,
                                    itemCount: homeProvider.allCharacter.length,
                                    itemBuilder: (context, index) {
                                      final character =
                                          homeProvider.allCharacter[index];

                                      return Padding(
                                        key: const Key('widget_character_info'),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        child: ListTile(
                                        key: Key('widget_character_info_$index'),
                                          leading: Image.network(
                                            character.imageUrl ?? '',
                                            fit: BoxFit.fill,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return const SizedBox(
                                                width: 30,
                                                height: 30,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.grey,
                                                  strokeWidth: 1,
                                                ),
                                              );
                                            },
                                          ),
                                          title: Text(character.name ?? ''),
                                        ),
                                      );
                                    },
                                  ),
                                  if (isLoadingMoreValues)
                                    Positioned(
                                      left: 0,
                                      bottom: 0,
                                      child: SizedBox(
                                        width: constraints.maxWidth,
                                        height: 80,
                                        child: const Center(
                                          child: SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 1.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
              Visibility(
                key: const Key('info_all_data_is_loading'),
                visible: homeProvider.allLoaded,
                child: const SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: Center(
                    child: Text(
                      'Todos os Dados Foram Carregados',
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() => isLoadingInitialValues = true);
                  FocusScope.of(context).unfocus();
                  await fetchData();
                  setState(() => isLoadingInitialValues = false);
                },
                child:
                    Text(homeProvider.hasError ? "Tentar Novamente" : 'Buscar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
