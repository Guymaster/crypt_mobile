class File {
  int id;
  String content;
  String title;
  int collectionId;
  int? createdAt = DateTime.timestamp().millisecondsSinceEpoch;
  int? updatedAt = DateTime.timestamp().millisecondsSinceEpoch;

  File({required this.id, required this.collectionId, required this.title, required this.content, this.createdAt, this.updatedAt});
}