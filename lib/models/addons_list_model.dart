class AddonsList {
  final int? id;
  final String? type;
  final String? fileName;
  final String? previewUrl;
  final String? title;
  final String? extension;

  AddonsList({
    required this.id,
    required this.type,
    required this.fileName,
    required this.previewUrl,
    required this.title,
    required this.extension,
  });

  factory AddonsList.fromJson(Map<String, dynamic> json) {
    return AddonsList(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      fileName: json['fileName'] ?? '',
      previewUrl: json['previewUrl'] ?? '',
      title: json['title'] ?? '',
      extension: json['extension'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'fileName': fileName,
      'previewUrl': previewUrl,
      'title': title,
      'extension': extension,
    };
  }
}
