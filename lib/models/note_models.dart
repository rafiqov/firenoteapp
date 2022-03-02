class Note {
  String? key;
  String? userId;
  String title;
  String content;
  String? imgUrl;

  Note({this.userId, required this.title, required this.content, this.imgUrl, this.key});
  Note.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        title = json['title'],
        content = json['content'],
        imgUrl = json['img_url'],
        key = json['key'];


  Map<String, dynamic> toJson() => {
    'userId': userId,
    'title': title,
    'content': content,
    'img_url': imgUrl,
  };
}