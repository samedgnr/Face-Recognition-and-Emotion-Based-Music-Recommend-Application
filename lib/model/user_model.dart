class User {
  final String name;
  final String number;
  final String email;
  final String password;

  User(
      {required this.number,
      required this.name,
      required this.email,
      required this.password});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
      'email': email,
      'password': password,
    };
  }

  // Implement toString to make it easier to see information about
  // each user when using the print statement.
  @override
  String toString() {
    return 'User{name: $name, number: $number, email: $email, password: $password}';
  }
}
