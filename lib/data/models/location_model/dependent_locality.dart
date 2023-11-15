class DependentLocality {
  String? dependentLocalityName;

  DependentLocality({this.dependentLocalityName});

  DependentLocality.fromJson(Map<String, dynamic> json) {
    dependentLocalityName = json['DependentLocalityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DependentLocalityName'] = this.dependentLocalityName;
    return data;
  }
}
