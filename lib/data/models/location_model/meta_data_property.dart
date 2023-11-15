import 'package:lesson62_final_project_part1/data/models/location_model/location_model.dart';

class MetaDataProperty {
  GeocoderResponseMetaData? geocoderResponseMetaData;

  MetaDataProperty({this.geocoderResponseMetaData});

  MetaDataProperty.fromJson(Map<String, dynamic> json) {
    geocoderResponseMetaData = json['GeocoderResponseMetaData'] != null
        ? new GeocoderResponseMetaData.fromJson(
            json['GeocoderResponseMetaData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geocoderResponseMetaData != null) {
      data['GeocoderResponseMetaData'] =
          this.geocoderResponseMetaData!.toJson();
    }
    return data;
  }
}
