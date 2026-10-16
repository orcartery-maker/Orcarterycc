class GameInfo {
  final String id;
  final String title;
  final String description;
  final String category;
  final String emoji;
  final bool isOnline;

  const GameInfo({
    this.id = '',
    required this.title,
    required this.description,
    required this.category,
    required this.emoji,
    this.isOnline = false,
  });

  GameInfo copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? emoji,
    bool? isOnline,
  }) {
    return GameInfo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'emoji': emoji,
      'isOnline': isOnline,
    };
  }

  factory GameInfo.fromJson(Map<String, dynamic> json) {
    return GameInfo(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      emoji: json['emoji'] as String? ?? '🎮',
      isOnline: json['isOnline'] as bool? ?? false,
    );
  }
}
