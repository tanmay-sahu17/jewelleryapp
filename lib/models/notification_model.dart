enum ShopNotificationKind {
  general,
  rate,
  offer,
  status,
}

class ShopNotification {
  const ShopNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.kind,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final ShopNotificationKind kind;
  final bool isRead;

  ShopNotification copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? createdAt,
    ShopNotificationKind? kind,
    bool? isRead,
  }) {
    return ShopNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      kind: kind ?? this.kind,
      isRead: isRead ?? this.isRead,
    );
  }
}
