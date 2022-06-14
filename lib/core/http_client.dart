
import 'package:hasura_connect/hasura_connect.dart';

final _connection = HasuraConnect("https://rickandmortyapi.com/graphql");

abstract class IHttpClient {
  Future<dynamic> get(String path);
}

class HttpClient implements IHttpClient {

  @override
  Future<dynamic> get(String query) async => (await _connection.query(query)as Map)['data'];
}