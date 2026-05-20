import 'opal_models.dart';

final ic2Level = OpalLevel(
  id: 'IC2',
  name: 'IC2 — Time Series',
  description: 'Time-series aggregations and top-K analysis.',
  examples: [
    OpalExample(
      title: 'Example 4: Time-Series Aggregation with timechart',
      scenario:
          'Visualize error rates over time, broken down by service, using 5-minute buckets.',
      sourceDataset: 'Application Logs (query window: last 6 hours)',
      query: '''filter severity = "ERROR"
timechart 5m, error_count:count(1), group_by(service)''',
      tip:
          'timechart produces streamable output (can be accelerated into a Dataset), while statsby is unstreamable (useful only in Worksheets for ad-hoc queries).',
    ),
    OpalExample(
      title: 'Example 5: Top-K Analysis',
      scenario: 'Find the top 5 endpoints by request count.',
      sourceDataset: 'HTTP Access Logs',
      query: '''make_col endpoint: concat(method, " ", path)
topk 5, count:count(1), group_by(endpoint)''',
      tip:
          'topk is a convenient shorthand for aggregation + sort + limit. It returns the top N groups by a given metric.',
    ),
  ],
);
