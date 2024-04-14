
class Collection {
  int id;
  String name;
  int? createdAt = DateTime.timestamp().millisecondsSinceEpoch;
  int? updatedAt = DateTime.timestamp().millisecondsSinceEpoch;

  Collection({required this.id, required this.name, this.createdAt, this.updatedAt});
}