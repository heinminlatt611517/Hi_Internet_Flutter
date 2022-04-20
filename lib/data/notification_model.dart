
class NotiModel {
  final int id;
  final String title;
  final String body;
  final String message;
  final String type_name;
  final String action_url;
  final String created;

  NotiModel(this.id, this.title, this.body, this.message, this.type_name, this.action_url, this.created);

  NotiModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        body = json['body'],
        id = json['id'],
        message = json['message'],
        type_name = json['type_name'],
        action_url = json['action_url'],
        created = json['created'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'message': message,
    'type_name': type_name,
    'action_url': action_url,
    'created': created
  };

  @override
  String toString() {
    return 'Dog{id: $id, title: $title, body: $body, message: $message, type_name: $type_name, action_url: $action_url}';
  }

}
