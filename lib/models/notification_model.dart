class NotificationItem {
  final int id;
  final String title;
  final String body;
  final DateTime date;
  final String? imageUrl;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.imageUrl,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      date: DateTime.parse(json['date'] as String),
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
