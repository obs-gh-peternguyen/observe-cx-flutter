import 'opal_models.dart';

final ic4Level = OpalLevel(
  id: 'IC4',
  name: 'IC4 — Advanced Time',
  description: 'Time comparisons, subqueries, and dynamic thresholds.',
  examples: [
    OpalExample(
      title: 'Example 9: Time-Series Comparison with timewrap',
      scenario:
          "Compare this week's error rate against last week to identify anomalies.",
      sourceDataset: 'Application Logs (query window: last 2 weeks)',
      query: '''filter severity = "ERROR"
timechart 1h, error_count:count(1)
timewrap 1w''',
      tip:
          'timewrap is essential for week-over-week or day-over-day comparisons. Rendered as overlapping line charts, anomalous spikes become immediately visible.',
    ),
    OpalExample(
      title: 'Example 10: Subqueries for Dynamic Thresholds',
      scenario:
          'Find services whose error rate exceeds 2x their 7-day average.',
      sourceDataset: 'Application Logs',
      query: '''filter severity = "ERROR"
timechart 1h, error_count:count(1), group_by(service)

filter error_count > 2 * (
  @"Application Logs"
  | filter severity = "ERROR"
  | timechart 1h, baseline:count(1), group_by(service)
  | timeshift 7d
  | statsby avg_baseline:avg(baseline), group_by(service)
).avg_baseline''',
      tip:
          'Subqueries allow you to compute dynamic thresholds inline. Here the baseline is the 7-day average error rate per service, and we alert when current exceeds 2x that baseline.',
    ),
  ],
);
