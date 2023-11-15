import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:lesson62_final_project_part1/core/services/map_service/yandex_map_services.dart';
import 'package:lesson62_final_project_part1/data/models/location_model/location_model.dart';
import 'package:lesson62_final_project_part1/data/repositories/location_repository.dart';
import 'package:meta/meta.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository repository;

  LocationBloc({required this.repository}) : super(LocationInitial()) {
    on<GetLocationEvent>((event, emit) async {
      emit(LocationLoading());

      try {
        final result = await repository.getLocation(
          appLatLong: event.appLatLong,
        );
        emit(
          LocationSuccess(locationModel: result),
        );
      } catch (e) {
        if (e is DioException) {
          emit(
            LocationError(errorText: e.response?.data ?? ''),
          );
        } else {
          emit(
            LocationError(
              errorText: e.toString(),
            ),
          );
        }
      }
    });

    on<GetLocationEventByAddress>((event, emit) async {
      emit(LocationLoading());

      try {
        final result = await repository.getLocationByAddress(
          street: event.street,
          houseNumber: event.houseNumber,
        );
        emit(
          LocationSuccess(locationModel: result),
        );
      } catch (e) {
        if (e is DioException) {
          emit(
            LocationError(errorText: e.response?.data ?? ''),
          );
        } else {
          emit(
            LocationError(
              errorText: e.toString(),
            ),
          );
        }
      }
    });
  }
}
