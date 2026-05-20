import 'opal_models.dart';

final ic3Level = OpalLevel(
  id: 'IC3',
  name: 'IC3 — Intermediate',
  description: 'JSON parsing, joins, and regular expressions.',
  examples: [
    OpalExample(
      title: 'Example 6: Parsing JSON and Extracting Nested Fields',
      scenario:
          'Raw application events arrive with a JSON body. Parse the JSON and extract meaningful fields.',
      sourceDataset: 'Datastream/Raw Events',
      query: '''make_col parsed:parse_json(string(FIELDS))
make_col
  service:string(parsed.service),
  event_type:string(parsed.event.type),
  event_status:string(parsed.event.status),
  error_code:int64(parsed.event.error.code),
  error_message:string(parsed.event.error.message),
  user_id:string(parsed.user.id),
  user_tier:string(parsed.user.tier)
filter event_status = "failed"
pick_col timestamp, service, event_type, error_code, error_message, user_id, user_tier''',
      tip:
          'JSON parsing is one of the most common operations in Observe. The parse_json() function converts a string column into a structured object you can navigate with dot notation.',
    ),
    OpalExample(
      title: 'Example 7: Enriching Logs via leftjoin',
      scenario:
          'Enrich application error logs with Kubernetes pod metadata to understand which nodes and namespaces are affected.',
      sourceDataset: 'Application Logs + Kubernetes/Pod (resource dataset)',
      query: '''filter severity = "ERROR"
leftjoin pod_name = @"Kubernetes/Pod".name,
  namespace:@"Kubernetes/Pod".namespace,
  node_name:@"Kubernetes/Pod".node_name,
  pod_status:@"Kubernetes/Pod".status,
  restart_count:@"Kubernetes/Pod".restart_count
pick_col timestamp, service, message, pod_name, namespace, node_name, pod_status, restart_count''',
      tip:
          'The leftjoin against a resource dataset is temporal — Observe automatically resolves which version of the pod resource was active at the time of each log event.',
    ),
    OpalExample(
      title: 'Example 8: Regular Expressions — Extract and Analyze',
      scenario:
          'Parse structured data from unstructured Nginx access log messages and analyze response patterns.',
      sourceDataset: 'Nginx Access Logs',
      query: r'''extract_regex message, 
  /\"(?P<method>GET|POST|PUT|DELETE|PATCH)\s+(?P<path>\/\S+)\s+HTTP\/\S+\"\s+(?P<status>\d{3})\s+(?P<bytes>\d+)/
make_col
  status_code:int64(status),
  bytes_sent:int64(bytes),
  status_class:concat(substring(status, 1, 1), "xx")
filter status_code >= 400
statsby 
  error_count:count(1),
  avg_bytes:avg(bytes_sent),
  group_by(method, path, status_class)
sort desc(error_count)''',
      tip:
          'extract_regex uses named capture groups (?P<name>) to create new columns directly from regex matches. This is extremely powerful for parsing unstructured log formats.',
    ),
  ],
);
