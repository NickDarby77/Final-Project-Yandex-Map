class YandexMapService {}

class AppLatLong {
  final double lat;
  final double long;

  const AppLatLong({
    required this.lat,
    required this.long,
  });
}

class BishkekLocation extends AppLatLong {
  const BishkekLocation({
    super.lat = 42.8543,
    super.long = 74.5737,
  });
}
