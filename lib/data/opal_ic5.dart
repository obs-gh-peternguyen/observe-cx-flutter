import 'opal_models.dart';

final ic5Level = OpalLevel(
  id: 'IC5',
  name: 'IC5 — Expert',
  description:
      'Resource datasets, metrics, complex event processing, sessions, multi-dataset correlation, and anomaly detection.',
  examples: [
    OpalExample(
      title: 'Example 11: Building a Resource Dataset from Kubernetes Events',
      scenario:
          'Transform raw Kubernetes pod events into a Resource Dataset that tracks pod lifecycle.',
      sourceDataset: 'Datastream/Kubernetes (raw observations)',
      query: '''filter OBSERVATION_KIND = "k8s_pod"
make_col
  uid:string(FIELDS.metadata.uid),
  pod_name:string(FIELDS.metadata.name),
  namespace:string(FIELDS.metadata.namespace),
  node_name:string(FIELDS.spec.nodeName),
  image:string(FIELDS.spec.containers[0].image),
  phase:string(FIELDS.status.phase)

make_resource options(expiry:4h),
  primarykey(uid),
  pod_name,
  namespace,
  node_name,
  image,
  phase

set_label pod_name
set_link "Kubernetes/Namespace", namespace:@"Kubernetes/Namespace".name
set_link "Kubernetes/Node", node_name:@"Kubernetes/Node".name''',
      tip:
          'make_resource converts events into a Resource Dataset with temporal versioning. The primarykey defines which field uniquely identifies each resource instance.',
    ),
    OpalExample(
      title: 'Example 12: Metric Definition with Rollup and Percentiles',
      scenario:
          'Create a latency metric Dataset from tracing spans with multiple percentile rollups.',
      sourceDataset: 'Tracing/Span (OpenTelemetry spans)',
      query: '''filter span.kind = "SERVER"
make_col latency_ms: float64(duration_ns) / 1000000.0

align 1m,
  p50:percentile(latency_ms, 50),
  p95:percentile(latency_ms, 95),
  p99:percentile(latency_ms, 99),
  avg_latency:avg(latency_ms),
  request_count:count(1),
  error_count:count_if(status_code = "ERROR"),
  group_by(service.name, span.name)''',
      tip:
          'The align verb creates fixed time windows that are streamable, making this suitable for an accelerated Dataset that powers real-time dashboards.',
    ),
    OpalExample(
      title: 'Example 13: Complex Event Processing with follow',
      scenario:
          'Detect suspicious access patterns — a login event followed by an API key creation within 2 minutes (potential account compromise).',
      sourceDataset: 'Auth/Audit Events',
      query: '''follow options(max_interval: 2m),
  login_event: filter action = "login",
  key_creation: filter action = "create_api_key"
| filter login_event.user_id = key_creation.user_id
| make_col
    user:login_event.user_id,
    login_ip:login_event.source_ip,
    login_time:login_event.timestamp,
    key_create_time:key_creation.timestamp,
    key_create_ua:key_creation.user_agent,
    time_to_key:key_creation.timestamp - login_event.timestamp,
    ip_match: login_event.source_ip = key_creation.source_ip
| pick_col login_time, user, login_ip, key_create_time, time_to_key, key_create_ua, ip_match''',
      tip:
          'The follow verb detects sequential event patterns across time. It is essential for security use cases like detecting account compromise or fraud patterns.',
    ),
    OpalExample(
      title: 'Example 14: Session Analysis from Clickstream Data',
      scenario:
          'Build user sessions from raw page view events and compute engagement metrics.',
      sourceDataset: 'Web Analytics/Page Views',
      query: '''make_session options(
    idle_timeout: 30m,
    max_duration: 24h
  ),
  session_key(user_id),
  session_start,
  session_end,
  page_views:count(1),
  unique_pages:count_distinct(page_url),
  avg_load_time:avg(load_time_ms),
  entry_page:any(page_url),
  exit_page:any_last(page_url)
make_col session_duration_min: float64(session_end - session_start) / 60000000000.0
pick_col user_id, session_start, session_end, session_duration_min, page_views, unique_pages, avg_load_time, entry_page, exit_page''',
      tip:
          'make_session groups events into sessions based on idle timeout and max duration. It automatically computes session boundaries from event timestamps.',
    ),
    OpalExample(
      title: 'Example 15: Multi-Dataset Pipeline — Full Incident Correlation',
      scenario:
          'Correlate HTTP 5xx errors with Kubernetes pod health and recent deployments to perform root cause analysis.',
      sourceDataset:
          'HTTP Access Logs + Kubernetes/Pod + Deployments/Events',
      query: '''// Step 1: Start from HTTP 5xx errors
@"HTTP Access Logs"
| filter status_code >= 500
| make_col endpoint: concat(method, " ", path)

// Step 2: Enrich with pod metadata (temporal join)
| leftjoin pod_name = @"Kubernetes/Pod".name,
    namespace:@"Kubernetes/Pod".namespace,
    node_name:@"Kubernetes/Pod".node_name,
    pod_phase:@"Kubernetes/Pod".phase,
    image:@"Kubernetes/Pod".image,
    restarts:@"Kubernetes/Pod".restart_count

// Step 3: Correlate with recent deployments
| leftjoin service = @"Deployments/Events".service_name,
    deploy_version:@"Deployments/Events".version,
    deploy_time:@"Deployments/Events".deployed_at,
    deployer:@"Deployments/Events".triggered_by

// Step 4: Aggregate into a summary
| statsby
    error_count:count(1),
    affected_pods:count_distinct(pod_name),
    affected_endpoints:count_distinct(endpoint),
    avg_restarts:avg(restarts),
    latest_deploy:max(deploy_version),
    group_by(service, namespace, node_name, deploy_version, deployer)
| sort desc(error_count)''',
      tip:
          'Multi-dataset pipelines combine events, resources, and metadata for root cause analysis. Temporal joins automatically resolve the correct resource state at each event time.',
    ),
    OpalExample(
      title: 'Example 16: Metric Rate Calculation and Anomaly Detection',
      scenario:
          'Calculate request rates from a cumulative counter metric and detect anomalies by comparing to a rolling average.',
      sourceDataset: 'Prometheus Metrics (counter-type)',
      query: '''filter metric_name = "http_requests_total"
align 5m,
  request_rate:rate(value),
  group_by(service, endpoint)
make_col
  rolling_avg: window(avg(request_rate), frame(rows: -12, 0)),
  deviation: request_rate - window(avg(request_rate), frame(rows: -12, 0)),
  is_anomaly: abs(request_rate - window(avg(request_rate), frame(rows: -12, 0))) 
              > 2.0 * window(stddev(request_rate), frame(rows: -12, 0))
filter is_anomaly = true
pick_col _c_valid_from, service, endpoint, request_rate, rolling_avg, deviation
sort desc(abs(deviation))''',
      tip:
          'Window functions like window(avg(...), frame(...)) enable rolling calculations essential for anomaly detection. The 2-sigma threshold flags statistically significant deviations.',
    ),
  ],
);
