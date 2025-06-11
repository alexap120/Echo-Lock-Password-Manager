import 'package:hive/hive.dart';

part 'notes_item.g.dart';

@HiveType(typeId: 1) // Use a different typeId from LoginItem!
class NoteItem extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  String? firestoreId;

  NoteItem({
    required this.title,
    required this.content,
    this.firestoreId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }

  factory NoteItem.fromJson(Map<String, dynamic> json) {
    return NoteItem(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
