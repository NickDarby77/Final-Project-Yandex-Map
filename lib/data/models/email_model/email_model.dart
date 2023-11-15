class EmailModel {
  String? name;
  String? pickUp;
  String? dropOff;
  String? type;
  String? date;

  EmailModel({this.name, this.pickUp, this.dropOff, this.type, this.date});

  EmailModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    pickUp = json['pickUp'];
    dropOff = json['dropOff'];
    type = json['type'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['pickUp'] = this.pickUp;
    data['dropOff'] = this.dropOff;
    data['type'] = this.type;
    data['date'] = this.date;
    return data;
  }
}
