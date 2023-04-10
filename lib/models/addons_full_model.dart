class AddonsFull {
  final int? countDownload;
  final int? countLikes;
  final int? countPeopleWhoRate;
  final Map<String, dynamic>? description;
  final String? downloadUrl;
  final String? extension;
  final String? fileName;
  final int? id;
  final String? previewUrl;
  final int? rating;
  final String? size;
  final String? title;
  final String? type;
  final String? seed;

  AddonsFull({
    required this.countDownload,
    required this.countLikes,
    required this.countPeopleWhoRate,
    required this.description,
    required this.downloadUrl,
    required this.rating,
    required this.size,
    required this.id,
    required this.type,
    required this.fileName,
    required this.previewUrl,
    required this.title,
    required this.extension,
    required this.seed
  });

  factory AddonsFull.fromJson(Map<String, dynamic> json) {
    return AddonsFull(
      countDownload: json['countDownload'].toInt(),
      countLikes: json['countLikes'].toInt() ?? 0,
      countPeopleWhoRate: json['countPeopleWhoRate'].toInt() ?? 0,
      description: json['description'] ?? '',
      downloadUrl: json['downloadUrl'] ?? '',
      rating: json['rating'].toInt() ?? 0,
      size: json['size'] ?? '',
      id: json['id'].toInt() ?? 0,
      type: json['type'] ?? '',
      fileName: json['fileName'] ?? '',
      previewUrl: json['previewUrl'] ?? '',
      title: json['title'] ?? '',
      extension: json['extension'] ?? '',
      seed: json['seed'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'countDownload': countDownload,
      'countLikes': countLikes,
      'countPeopleWhoRate': countPeopleWhoRate,
      'description': description,
      'downloadUrl': downloadUrl,
      'rating': rating,
      'size': size,
      'id': id,
      'type': type,
      'fileName': fileName,
      'previewUrl': previewUrl,
      'title': title,
      'extension': extension,
      'seed': seed
    };
  }
}
