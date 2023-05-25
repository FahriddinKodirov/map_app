class UserDataModel {
  num latt;
  num long;

  UserDataModel({
            required this.latt,
            required this.long,
           });
  factory UserDataModel.fromJson(Map<String, dynamic> jsonData) {
    return UserDataModel(
       latt: jsonData['latt'] ?? 0.0, 
       long: jsonData['long'] ?? 0.0, 
       );
  }

  Map<String, dynamic> toJson() => 
   {
    'latt':latt,
    'long':long,
  };
}