import 'package:fpdart/fpdart.dart';
import '../error/failure.dart';

/// Base asynchronous business logic operational contract.
/// [Type] represent karta hai returned successful parsed content entity data model ko.
/// [Params] define karta hai business action ko complete karne ke liye necessary inputs parameter profile ko.
abstract interface class UseCase<Type, Params> {

  /// Business execution trigger operation contract thread.
  /// Throws zero implicit exceptions. Return boundaries explicit state failures inside a future block.
  Future<Either<Failure, Type>> call(Params params);
}

/// Helper representation semantic class to communicate empty input execution requests.
/// Is class ko tab use kiya jata hai jab kisi operations ko perform karne ke liye parameters ki zaroorat nahi hoti (e.g., GetProductsList).
class NoParams {
  const NoParams();
}
