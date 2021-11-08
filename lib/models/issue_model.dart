class Issue {
  final int id;
  // ignore: non_constant_identifier_names
  final List character_credits;
  // ignore: non_constant_identifier_names
  final List team_credits;
  // ignore: non_constant_identifier_names
  final List location_credits;

  Issue(
      {required this.id,
      // ignore: non_constant_identifier_names
      required this.character_credits,
      // ignore: non_constant_identifier_names
      required this.team_credits,
      // ignore: non_constant_identifier_names
      required this.location_credits});

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
        id: json['id'] ?? 0,
        character_credits: json['character_credits'] ?? [],
        team_credits: json['team_credits'] ?? [],
        location_credits: json['location_credits'] ?? []);
  }
}
