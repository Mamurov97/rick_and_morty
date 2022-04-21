// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/common/app_colors.dart';
import 'package:untitled/features/home/presentation/bloc/person_list/person_list_cubit.dart';
import 'package:untitled/features/home/presentation/bloc/search/search_bloc.dart';
import 'package:untitled/features/home/presentation/pages/person_screen.dart';
import 'package:untitled/di/di.dart' as di;
import 'package:dcdg/dcdg.dart';

import 'di/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PersonListCubit>(
            create: (context) => sl<PersonListCubit>()..loadPerson()),
        BlocProvider<SearchBloc>(
            create: (context) => sl<SearchBloc>()),
      ],
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          backgroundColor: AppColors.mainBackground,
          scaffoldBackgroundColor: AppColors.mainBackground,
        ),
        home: const HomePage(),
      ),
    );
  }
}

