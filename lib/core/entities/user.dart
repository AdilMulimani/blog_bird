//An entity which describes the fields of User
class User {
  final String id;
  final String email;
  final String name;

  const User({
    required this.id,
    required this.email,
    required this.name,
  });

  @override
  String toString() {
    return 'User{id: $id, email: $email, name: $name}';
  }
}
