import 'opal_models.dart';

final ic1Level = OpalLevel(
  id: 'IC1',
  name: 'IC1 — Basics',
  description: 'Filtering, column creation, and basic aggregation.',
  examples: [
    OpalExample(
      title: 'Example 1: Filtering Logs by Severity',
      scenario:
          'Find all ERROR-level logs from your microservices application.',
      sourceDataset: 'Application Logs',
      query: 'filter severity = "ERROR"',
      tip:
          'The filter verb is the most fundamental OPAL verb. Place filters as early as possible in your pipeline to reduce the data volume for subsequent operations.',
    ),
    OpalExample(
      title: 'Example 2: Creating Computed Columns',
      scenario:
          'Enrich HTTP access log data with a human-readable response time and an error flag.',
      sourceDataset: 'HTTP Access Logs',
      query: '''make_col
  response_time_ms: float64(response_time_ns) / 1000000.0,
  is_error: status_code >= 400,
  endpoint: concat(method, " ", path)
pick_col timestamp, endpoint, status_code, response_time_ms, is_error''',
      tip:
          'make_col creates new columns (or overwrites existing ones). pick_col selects only the columns you want, dropping everything else. Together they are the most common projection operations.',
    ),
    OpalExample(
      title: 'Example 3: Basic Aggregation — Error Count by Service',
      scenario:
          'Count the total number of errors per service over the last hour to identify which services are most problematic.',
      sourceDataset: 'Application Logs (query window: last 1 hour)',
      query: '''filter severity = "ERROR"
statsby error_count:count(1), group_by(service)
sort desc(error_count)''',
      tip:
          'The checkout service has ~3x more errors than the next service. This warrants immediate investigation.',
    ),
  ],
);
