import 'package:dio/dio.dart';
import 'package:lesson62_final_project_part1/core/consts/app_consts.dart';
import 'package:lesson62_final_project_part1/core/services/map_service/yandex_map_services.dart';
import 'package:lesson62_final_project_part1/data/models/location_model/location_model.dart';

class LocationRepository {
  final Dio dio;

  LocationRepository({required this.dio});

  Future<LocationModel> getLocation({required AppLatLong appLatLong}) async {
    final Response response = await dio.get(
      'https://geocode-maps.yandex.ru/1.x/?apikey=${AppConsts.geocoderApiKey}&geocode=${appLatLong.long},${appLatLong.lat}&lang=ru&format=json',
    );
    return LocationModel.fromJson(response.data);
  }

  Future<LocationModel> getLocationByAddress({
    required String street,
    required String houseNumber,
  }) async {
    final Response response = await dio.get(
      'https://geocode-maps.yandex.ru/1.x/?apikey=${AppConsts.geocoderApiKey}&geocode=Bishkek,+$street+$houseNumber&lang=ru&format=json',
    );
    return LocationModel.fromJson(response.data);
  }
}
