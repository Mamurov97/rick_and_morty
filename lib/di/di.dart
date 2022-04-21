import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/core/platform/network_info.dart';
import 'package:untitled/features/home/data/data_sources/person_local_data_source.dart';
import 'package:untitled/features/home/data/data_sources/person_remote_data_source.dart';
import 'package:untitled/features/home/data/repositories/person_repository_impl.dart';
import 'package:untitled/features/home/domain/repositories/person_repository.dart';
import 'package:untitled/features/home/domain/use_cases/get_all_persons.dart';
import 'package:untitled/features/home/presentation/bloc/person_list/person_list_cubit.dart';
import 'package:untitled/features/home/presentation/bloc/search/search_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => PersonListCubit(getAllPersons: sl<GetAllPersons>()));
  sl.registerFactory(() => SearchBloc(searchPerson: sl()));

  sl.registerLazySingleton(() => GetAllPersons(sl()));
  sl.registerLazySingleton(() => SearchPersons(sl()));

  sl.registerLazySingleton<PersonRepository>(
    () => PersonRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<PersonRemoteDataSource>(
      () => PersonRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<PersonLocalDataSource>(
      () => PersonLocalDataSourceImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
