part of 'location_bloc.dart';

@immutable
sealed class LocationEvent {}

final class GetLocationEvent extends LocationEvent {
  final AppLatLong appLatLong;

  GetLocationEvent({required this.appLatLong});
}

final class GetLocationEventByAddress extends LocationEvent {
  final String street;
  final String houseNumber;

  GetLocationEventByAddress({
    required this.street,
    required this.houseNumber,
  });
}
