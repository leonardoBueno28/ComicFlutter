class Issues {
  final String image;
  final int id;
  final String name;
  // ignore: non_constant_identifier_names
  final String date_added;
  // ignore: non_constant_identifier_names
  final String issue_number;
  // ignore: non_constant_identifier_names
  final String api_detail_url;

  Issues(
      {required this.image,
      required this.id,
      required this.name,
      // ignore: non_constant_identifier_names
      required this.date_added,
      // ignore: non_constant_identifier_names
      required this.issue_number,
      // ignore: non_constant_identifier_names
      required this.api_detail_url});

  factory Issues.fromJson(Map<String, dynamic> json) {
    return Issues(
        image: json['image']['original_url'] ?? [],
        id: json['id'] ?? 0,
        name: json['name'] ?? 'No data',
        date_added: json['date_added'] ?? '',
        issue_number: json['issue_number'] ?? '',
        api_detail_url: json['api_detail_url'] ?? '');
  }
}
