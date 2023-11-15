import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lesson62_final_project_part1/core/services/dio/dio_settings.dart';
import 'package:lesson62_final_project_part1/core/services/map_service/app_location.dart';
import 'package:lesson62_final_project_part1/core/services/map_service/yandex_map_services.dart';
import 'package:lesson62_final_project_part1/data/models/email_model/email_model.dart';
import 'package:lesson62_final_project_part1/data/repositories/location_repository.dart';
import 'package:lesson62_final_project_part1/main.dart';
import 'package:lesson62_final_project_part1/presentation/blocs/location_bloc/location_bloc.dart';
import 'package:lesson62_final_project_part1/presentation/blocs/order_bloc/order_bloc.dart';
import 'package:lesson62_final_project_part1/presentation/common_widgets/current_location_button.dart';
import 'package:lesson62_final_project_part1/presentation/common_widgets/custom_button.dart';
import 'package:lesson62_final_project_part1/presentation/common_widgets/menu_container.dart';
import 'package:lesson62_final_project_part1/presentation/theme/fonts/app_fonts.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;
  Animation<double>? _animationRadius;

  double opacity = 1;
  double radius = 300;

  AppLatLong currentLocation = const BishkekLocation();

  @override
  void dispose() {
    super.dispose();
    _animationController!.dispose();
  }

  @override
  void initState() {
    animation();
    super.initState();
    _initPermission().ignore();
  }

  List<MapObject> myMapObjects = [];
  final TextEditingController controller = TextEditingController();
  final mapControllerCompleter = Completer<YandexMapController>();
  int initialLabelIndex = 0;
  bool nightModeEnabled = false;
  String currentAddress = '';

  @override
  Widget build(BuildContext context) {
    addObjects(appLatLong: currentLocation);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Yandex Map',
          style: AppFonts.s26BoldIndigo,
        ),
        actions: [
          IconButton(
            onPressed: () {
              nightModeEnabled = !nightModeEnabled;
              setState(() {});
            },
            icon: Icon(
              Icons.sunny,
              color: nightModeEnabled ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _animationController!,
            builder: (context, child) {
              addObjects(appLatLong: currentLocation);

              return YandexMap(
                mapObjects: myMapObjects,
                onMapTap: (argument) {
                  BlocProvider.of<LocationBloc>(context).add(
                    GetLocationEvent(
                      appLatLong: AppLatLong(
                        lat: argument.latitude,
                        long: argument.longitude,
                      ),
                    ),
                  );
                  addMarker(
                    point: argument,
                    name: 'secondLocationMarker',
                  );
                },
                nightModeEnabled: nightModeEnabled,
                onMapCreated: (controller) {
                  mapControllerCompleter.complete(controller);
                },
              );
            },
          ),
          BlocConsumer<LocationBloc, LocationState>(
            listener: (context, state) {
              if (state is LocationLoading) {
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    content: CircularProgressIndicator.adaptive(),
                  ),
                );
              } else if (state is LocationSuccess) {
                Navigator.pop(context);

                controller.text = state
                        .locationModel
                        .response
                        ?.geoObjectCollection
                        ?.featureMember?[0]
                        .geoObject
                        ?.metaDataProperty
                        ?.geocoderMetaData
                        ?.address
                        ?.formatted ??
                    '';
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 29),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CurrentLocationButton(
                          onPressed: () {
                            _initPermission();
                          },
                        ),
                      ],
                    ),
                  ),
                  TextFieldUnfocus(
                    child: MenuContainer(
                      controller: controller,
                      onSearch: () async {
                        List<String> streetAndHouse =
                            controller.text.split(' ');

                        BlocProvider.of<LocationBloc>(context).add(
                          GetLocationEventByAddress(
                            street: streetAndHouse[0],
                            houseNumber: streetAndHouse[1],
                          ),
                        );

                        String targetLocation = await LocationRepository(
                          dio: DioSettings().dio,
                        )
                            .getLocationByAddress(
                                street: streetAndHouse[0],
                                houseNumber: streetAndHouse[1])
                            .then(
                              (value) =>
                                  value
                                      .response
                                      ?.geoObjectCollection
                                      ?.featureMember
                                      ?.first
                                      .geoObject
                                      ?.point
                                      ?.pos
                                      .toString() ??
                                  '',
                            );
                        AppLatLong targetLocationLatLong = AppLatLong(
                          lat: double.tryParse(
                                targetLocation.split(' ')[0],
                              ) ??
                              0,
                          long: double.tryParse(
                                targetLocation.split(' ')[1],
                              ) ??
                              0,
                        );
                        addMarker(
                          point: Point(
                            latitude: targetLocationLatLong.long,
                            longitude: targetLocationLatLong.lat,
                          ),
                          name: 'name',
                        );
                      },
                      onSwitch: (index) {
                        initialLabelIndex = index ?? 0;
                        setState(() {});
                      },
                      initialLabelIndex: initialLabelIndex,
                    ),
                  ),
                  BlocListener<OrderBloc, OrderState>(
                    listener: (context, state) {
                      if (state is OrderSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Your order has been created successfuly',
                            ),
                          ),
                        );
                      }
                    },
                    child: CustomButton(
                      onPressed: () {
                        BlocProvider.of<OrderBloc>(context).add(
                          SendOrderEvent(
                            model: EmailModel(
                              name: 'Nick Darby',
                              pickUp: currentAddress,
                              dropOff: controller.text,
                              type: initialLabelIndex == 0
                                  ? 'Transport'
                                  : 'Delivery',
                              date: DateTime.now().toString(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = BishkekLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    currentLocation = location;
    _moveToCurrentLocation(location);
    currentAddress = await LocationRepository(
      dio: DioSettings().dio,
    ).getLocation(appLatLong: location).then(
          (value) =>
              value.response?.geoObjectCollection?.featureMember?[0].geoObject
                  ?.metaDataProperty?.geocoderMetaData?.address?.formatted ??
              '',
        );
  }

  Future<void> _moveToCurrentLocation(AppLatLong appLatLong) async {
    (await mapControllerCompleter.future).moveCamera(
      animation: const MapAnimation(
        type: MapAnimationType.smooth,
        duration: 2,
      ),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: appLatLong.lat,
            longitude: appLatLong.long,
          ),
          zoom: 14,
        ),
      ),
    );
  }

  void addObjects({required AppLatLong appLatLong}) {
    final myLocationMarker = PlacemarkMapObject(
      opacity: 0.8,
      mapId: const MapObjectId('currentLocation'),
      point: Point(
        latitude: appLatLong.lat,
        longitude: appLatLong.long,
      ),
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage(
            'assets/images/map.png',
          ),
          scale: 0.1,
          rotationType: RotationType.rotate,
        ),
      ),
    );

    final currentLocationCircle = CircleMapObject(
      mapId: const MapObjectId('currentLocationCircle'),
      circle: Circle(
        center: Point(
          latitude: appLatLong.lat,
          longitude: appLatLong.long,
        ),
        radius: radius,
      ),
      strokeWidth: 0,
      fillColor: Colors.yellow.withOpacity(opacity),
    );

    myMapObjects.addAll(
      [currentLocationCircle, myLocationMarker],
    );
  }

  void addMarker({required Point point, required String name}) {
    myMapObjects.add(
      PlacemarkMapObject(
        opacity: 0.8,
        mapId: MapObjectId(name),
        point: point,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(
              'assets/images/marker.png',
            ),
            scale: 0.3,
            rotationType: RotationType.rotate,
          ),
        ),
      ),
    );
    setState(() {});
  }

  void animation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
    );
    _animationRadius =
        Tween(begin: 15.0, end: 400.0).animate(_animationController!)
          ..addListener(
            () {
              radius = _animationRadius!.value;
            },
          );
    _animation = Tween(begin: 0.1, end: 1.0).animate(
      _animationController!,
    )..addListener(
        () {
          opacity = _animation!.value;
        },
      );
    _animationController!.repeat(reverse: true);
  }
}
