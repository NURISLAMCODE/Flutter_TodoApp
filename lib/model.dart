class TodoModel {
  final int? id;
  final String? title;
  final String? desc;
  TodoModel({this.id, this.title, this.desc});

  TodoModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        desc = res['desc'];

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "title": title,
      "desc": desc,
    };
  }
}
