class UserEntity {
  String? name;
  String? age;
  String? address;
  String? job;
  String? email;

  UserEntity({
      this.name, 
      this.age, 
      this.address, 
      this.job, 
      this.email});

  UserEntity.fromJson(dynamic json) {
    name = json['name'];
    age = json['age'];
    address = json['address'];
    job = json['job'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['age'] = age;
    map['address'] = address;
    map['job'] = job;
    map['email'] = email;
    return map;
  }

}