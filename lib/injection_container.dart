import 'package:clean_architecture_tdd_course/core/network/network_info.dart';

import 'package:clean_architecture_tdd_course/core/utils/input_converter.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart ' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //**--Features : NumberTrivia
  //Presentation
  sl.registerFactory(() => NumberTriviaBLoc(
      getConcreteNumberTrivia: sl(),
      getRadnomNumberTrivia: sl(),
      inputConveter: sl()));
  //usecases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(
      () => GetRadnomNumberTrivia(numberTriviaRepository: sl()));
  //Repositories
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          numberTriviaLocalDataSource: sl(),
          numberTriviaRemoteDataSource: sl(),
          netWorkInfo: sl()));

  //DataSources
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));

  //**--Core
  sl.registerLazySingleton(() => InputConveter());
  sl.registerLazySingleton<NetWorkInfo>(() => NetworkInfoImpl(sl()));

  //**--External Dependicies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
