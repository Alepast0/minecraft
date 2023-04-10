
class Categories{
  final String id;
  final String image;
  final String title;

  Categories({required this.title, required this.image, required this.id});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['id'],
      image: json['image'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
    };
  }
}