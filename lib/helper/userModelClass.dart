class Users {
  int? id;
  String? name;
  String? email;
  String? mobile;
  String? image;
  String? city;
  String? password;
  bool? isAdmin;

  Users({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.image,
    this.city,
    this.password,
    this.isAdmin ,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'image': image,
      'city': city,
      'password': password,
      'isAdmin': isAdmin! ? 1 : 0,
    };
  }

  static Users fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      mobile: map['mobile'],
      image: map['image'],
      city: map['city'],
      password: map['password'],
      isAdmin: map['isAdmin'] == 1,
    );
  }
}
