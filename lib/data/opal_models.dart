class OpalExample {
  final String title;
  final String scenario;
  final String sourceDataset;
  final String query;
  final String tip;

  const OpalExample({
    required this.title,
    required this.scenario,
    required this.sourceDataset,
    required this.query,
    required this.tip,
  });
}

class OpalLevel {
  final String id;
  final String name;
  final String description;
  final List<OpalExample> examples;

  const OpalLevel({
    required this.id,
    required this.name,
    required this.description,
    required this.examples,
  });
}
