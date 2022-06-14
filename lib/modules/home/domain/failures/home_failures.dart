abstract class HomeFailure implements Exception {
  final String? message;

  HomeFailure(this.message);
}

class HomeUnknownFailure extends HomeFailure {
  HomeUnknownFailure(String? message) : super(message);
}

class HomeNotFindFailure extends HomeFailure {
  HomeNotFindFailure(String? message) : super(message);
}