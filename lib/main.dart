import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lesson62_final_project_part1/core/services/dio/dio_settings.dart';
import 'package:lesson62_final_project_part1/data/repositories/location_repository.dart';
import 'package:lesson62_final_project_part1/data/repositories/order_repository.dart';
import 'package:lesson62_final_project_part1/presentation/blocs/location_bloc/location_bloc.dart';
import 'package:lesson62_final_project_part1/presentation/blocs/order_bloc/order_bloc.dart';
import 'package:lesson62_final_project_part1/presentation/screens/home_screen/map_screen.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => DioSettings(),
        ),
        RepositoryProvider(
          create: (context) => LocationRepository(
            dio: RepositoryProvider.of<DioSettings>(context).dio,
          ),
        ),
        RepositoryProvider(
          create: (context) => OrderRepository(
            dio: RepositoryProvider.of<DioSettings>(context).dio,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LocationBloc(
              repository: RepositoryProvider.of<LocationRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => OrderBloc(
              repository: RepositoryProvider.of<OrderRepository>(context),
            ),
          ),
        ], 
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: const MapScreen(),
        ),
      ),
    );
  }
}

class TextFieldUnfocus extends StatelessWidget {
  const TextFieldUnfocus({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          final FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild!.unfocus();
          }
        },
        child: child,
      );
}
