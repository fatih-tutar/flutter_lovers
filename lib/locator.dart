import 'package:flutterlovers/repository/user_repository.dart';
import 'package:flutterlovers/services/fake_auth_service.dart';
import 'package:flutterlovers/services/firebase_auth_service.dart';
import 'package:flutterlovers/services/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

void setupLocator(){
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirestoreDbService());
}