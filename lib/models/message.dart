class Message {
  final int id;
  final int senderId;
  final int receiverId;
  final String content;
  final String createdAt;
  final String readAt;

  Message({
    this.id,
    this.senderId,
    this.receiverId,
    this.content,
    this.createdAt,
    this.readAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return new Message(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      content: json['content'],
      createdAt: json['createdAt'],
      readAt: json['readAt'] ?? null,
    );
  }
}
