import 'package:lesson62_final_project_part1/data/models/location_model/location_model.dart';

class GeoObjectCollection {
  MetaDataProperty? metaDataProperty;
  List<FeatureMember>? featureMember;

  GeoObjectCollection({this.metaDataProperty, this.featureMember});

  GeoObjectCollection.fromJson(Map<String, dynamic> json) {
    metaDataProperty = json['metaDataProperty'] != null
        ? new MetaDataProperty.fromJson(json['metaDataProperty'])
        : null;
    if (json['featureMember'] != null) {
      featureMember = <FeatureMember>[];
      json['featureMember'].forEach((v) {
        featureMember!.add(new FeatureMember.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.metaDataProperty != null) {
      data['metaDataProperty'] = this.metaDataProperty!.toJson();
    }
    if (this.featureMember != null) {
      data['featureMember'] =
          this.featureMember!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
