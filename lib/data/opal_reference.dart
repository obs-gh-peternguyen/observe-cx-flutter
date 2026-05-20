class OpalRef {
  final String name;
  final String category;
  final String description;
  final String example;

  const OpalRef({
    required this.name,
    required this.category,
    required this.description,
    required this.example,
  });
}

final List<OpalRef> opalVerbs = [
  OpalRef(
    name: 'filter',
    category: 'Filter',
    description:
        'Exclude rows from the input dataset that do not match the given predicate expression.',
    example: 'filter severity = "ERROR" and service = "checkout"',
  ),
  OpalRef(
    name: 'filter_last',
    category: 'Filter',
    description:
        'Keeps rows whose boolean predicate is true and drops all others while preserving the input schema.',
    example: 'filter_last status = "Running"',
  ),
  OpalRef(
    name: 'topk',
    category: 'Filter',
    description:
        'Retains rows that belong to the highest-ranked groups in the current query window.',
    example: 'topk 10, request_count:count(1), group_by(endpoint)',
  ),
  OpalRef(
    name: 'bottomk',
    category: 'Filter',
    description:
        'Retains rows that belong to the lowest-ranked groups in the current query window.',
    example: 'bottomk 5, latency:avg(response_ms), group_by(service)',
  ),
  OpalRef(
    name: 'limit',
    category: 'Filter',
    description:
        'Select the first N rows based on the current ordering and filter out the rest.',
    example: 'sort desc(error_count)\nlimit 100',
  ),
  OpalRef(
    name: 'ever',
    category: 'Filter',
    description:
        'Keeps every row whose primary-key group had at least one row where the predicate was true.',
    example: 'ever status = "CrashLoopBackOff"',
  ),
  OpalRef(
    name: 'never',
    category: 'Filter',
    description:
        'Keeps every row whose primary-key group had no row where the predicate evaluated to true.',
    example: 'never status = "Running"',
  ),
  OpalRef(
    name: 'always',
    category: 'Filter',
    description:
        'Keeps every row whose primary-key group had the predicate true on every row in the window.',
    example: 'always cpu_usage < 80',
  ),
  OpalRef(
    name: 'make_col',
    category: 'Projection',
    description:
        'Evaluates one or more name:expression bindings per row, inserting new columns or replacing existing ones.',
    example:
        'make_col\n  latency_ms: float64(duration_ns) / 1000000.0,\n  is_error: status_code >= 400',
  ),
  OpalRef(
    name: 'pick_col',
    category: 'Projection',
    description:
        'Projects the pipeline to an explicit list of columns, dropping everything else.',
    example: 'pick_col timestamp, service, message, severity',
  ),
  OpalRef(
    name: 'drop_col',
    category: 'Projection',
    description:
        'Removes one or more named columns while preserving every other column.',
    example: 'drop_col raw_body, internal_id',
  ),
  OpalRef(
    name: 'rename_col',
    category: 'Projection',
    description: 'Renames existing columns using newName:@.oldName syntax.',
    example: 'rename_col host_name:@.hostname, svc:@.service_name',
  ),
  OpalRef(
    name: 'extract_regex',
    category: 'Projection',
    description:
        'Add one or more columns by matching named capture groups in a regex against a source expression.',
    example:
        r'extract_regex message, /(?P<method>GET|POST)\s+(?P<path>\/\S+)\s+(?P<status>\d{3})/',
  ),
  OpalRef(
    name: 'statsby',
    category: 'Aggregate',
    description:
        'Computes aggregate expressions over the input, optionally partitioned by group_by columns.',
    example:
        'statsby\n  total_errors:count(1),\n  avg_latency:avg(response_ms),\n  group_by(service)',
  ),
  OpalRef(
    name: 'timechart',
    category: 'Aggregate',
    description:
        'Bin (in time) and aggregate columns through time, based on grouping columns. Produces streamable output.',
    example: 'timechart 5m, error_count:count(1), group_by(service)',
  ),
  OpalRef(
    name: 'align',
    category: 'Aggregate',
    description:
        'Turns a raw metric-interface dataset into interval rows on a time grid by evaluating aggregate expressions.',
    example:
        'align 1m,\n  p95:percentile(latency_ms, 95),\n  request_count:count(1),\n  group_by(service)',
  ),
  OpalRef(
    name: 'aggregate',
    category: 'Aggregate',
    description:
        'Combine aggregate functions over metric columns while collapsing rows to the grouping keys.',
    example: 'aggregate sum(value), group_by(service, metric_name)',
  ),
  OpalRef(
    name: 'dedup',
    category: 'Aggregate',
    description:
        'Collapses duplicate rows while preserving the input column layout and dataset kind.',
    example: 'dedup service, endpoint',
  ),
  OpalRef(
    name: 'histogram',
    category: 'Aggregate',
    description:
        'Generate an approximated equi-width histogram for the selected expression.',
    example: 'histogram latency_ms, bins:20',
  ),
  OpalRef(
    name: 'pivot',
    category: 'Aggregate',
    description:
        'Rotates a table by transforming rows into columns.',
    example: 'pivot service, sum(error_count)',
  ),
  OpalRef(
    name: 'unpivot',
    category: 'Aggregate',
    description:
        'Rotates a table by transforming a list of columns into rows.',
    example: 'unpivot p50, p95, p99, name: "percentile", value: "latency"',
  ),
  OpalRef(
    name: 'rollup',
    category: 'Aggregate',
    description: 'Rollup raw metrics into aligned metrics.',
    example: 'rollup sum(value), 5m',
  ),
  OpalRef(
    name: 'timestats',
    category: 'Aggregate',
    description:
        'Aggregate columns at every point in time, based on optional grouping columns.',
    example: 'timestats avg_cpu:avg(cpu_percent), group_by(host)',
  ),
  OpalRef(
    name: 'fill',
    category: 'Aggregate',
    description:
        'Adds rows on an aligned temporal grid wherever a group has no row in an alignment bucket.',
    example: 'fill 0',
  ),
  OpalRef(
    name: 'join',
    category: 'Join',
    description:
        'Performs an inner join between the pipeline input and one other dataset.',
    example:
        'join pod_name = @"Kubernetes/Pod".name, node:@"Kubernetes/Pod".node_name',
  ),
  OpalRef(
    name: 'leftjoin',
    category: 'Join',
    description:
        'Performs a temporal left outer join, preserving every left-hand row and enriching with matching right-hand columns.',
    example:
        'leftjoin pod_name = @"Kubernetes/Pod".name,\n  namespace:@"Kubernetes/Pod".namespace',
  ),
  OpalRef(
    name: 'fulljoin',
    category: 'Join',
    description:
        'Performs a temporal full outer join — every row from either side appears.',
    example:
        'fulljoin user_id = @"User Events".user_id,\n  last_login:@"User Events".timestamp',
  ),
  OpalRef(
    name: 'lookup',
    category: 'Join',
    description:
        'Enriches each input row with columns from a related dataset using a left-outer temporal join. Keeps input dataset kind.',
    example:
        'lookup service_name = @"Service Registry".name,\n  owner:@"Service Registry".team',
  ),
  OpalRef(
    name: 'union',
    category: 'Join',
    description:
        'Combines the main pipeline with referenced additional datasets into one dataset.',
    example: 'union @"Staging Logs", @"Production Logs"',
  ),
  OpalRef(
    name: 'exists',
    category: 'Join',
    description:
        'Keeps rows from primary input where the join predicate matches at least one row from another dataset.',
    example: 'exists user_id = @"Premium Users".user_id',
  ),
  OpalRef(
    name: 'not_exists',
    category: 'Join',
    description:
        'Returns rows from primary input where the join predicate matches no row from the additional dataset.',
    example: 'not_exists pod_name = @"Healthy Pods".name',
  ),
  OpalRef(
    name: 'follow',
    category: 'Join',
    description:
        'Detects sequential event patterns — returns matches when events occur in a defined time order.',
    example:
        'follow options(max_interval: 5m),\n  login: filter action = "login",\n  access: filter action = "data_export"',
  ),
  OpalRef(
    name: 'follow_not',
    category: 'Join',
    description:
        'Returns rows where a follow pattern does NOT match within the interval.',
    example:
        'follow_not options(max_interval: 10m),\n  order: filter action = "order_placed",\n  confirm: filter action = "order_confirmed"',
  ),
  OpalRef(
    name: 'surrounding',
    category: 'Join',
    description:
        'Outer joins datasets by matching row time to a specified frame as well as column values.',
    example: 'surrounding 5m, host = @"Metrics".host',
  ),
  OpalRef(
    name: 'flatten',
    category: 'Semistructured',
    description:
        'Expands a column holding an object, array, or variant into many rows — one per nested path.',
    example: 'flatten tags',
  ),
  OpalRef(
    name: 'flatten_all',
    category: 'Semistructured',
    description:
        'Recursively flatten all child and intermediate elements into key-value columns.',
    example: 'flatten_all FIELDS',
  ),
  OpalRef(
    name: 'flatten_leaves',
    category: 'Semistructured',
    description:
        'Recursively flatten all child elements, returning only leaf values.',
    example: 'flatten_leaves config_object',
  ),
  OpalRef(
    name: 'flatten_single',
    category: 'Semistructured',
    description:
        'Flatten the first level of child elements into key-value columns.',
    example: 'flatten_single labels',
  ),
  OpalRef(
    name: 'make_resource',
    category: 'Metadata',
    description:
        'Creates a Resource dataset from an input Event or Interval dataset.',
    example:
        'make_resource options(expiry:4h),\n  primarykey(uid),\n  pod_name, namespace, phase',
  ),
  OpalRef(
    name: 'make_event',
    category: 'Metadata',
    description:
        'Creates an Event dataset from an input Table, Interval, or Resource dataset.',
    example: 'make_event',
  ),
  OpalRef(
    name: 'make_interval',
    category: 'Metadata',
    description:
        'Creates an Interval dataset from an input Table, Event, or Resource dataset.',
    example: 'make_interval start_col:start_time, end_col:end_time',
  ),
  OpalRef(
    name: 'make_metric',
    category: 'Metadata',
    description:
        'Creates a metric dataset from dataset with precomputed time grid.',
    example: 'make_metric',
  ),
  OpalRef(
    name: 'make_session',
    category: 'Metadata',
    description:
        'Group events or intervals close to each other into sessions and calculate aggregations.',
    example:
        'make_session options(idle_timeout: 30m),\n  session_key(user_id),\n  page_views:count(1)',
  ),
  OpalRef(
    name: 'make_table',
    category: 'Metadata',
    description:
        'Converts a non-Table dataset to kind Table by clearing temporal metadata.',
    example: 'make_table',
  ),
  OpalRef(
    name: 'set_label',
    category: 'Metadata',
    description:
        'Declare the label of the output to be the designated column.',
    example: 'set_label pod_name',
  ),
  OpalRef(
    name: 'set_link',
    category: 'Metadata',
    description:
        'Declares a foreign key from the current dataset to another for Data Graph navigation.',
    example:
        'set_link "Kubernetes/Node", node_name:@"Kubernetes/Node".name',
  ),
  OpalRef(
    name: 'set_primary_key',
    category: 'Metadata',
    description:
        'Declare the primary key of the output as consisting of one or more named columns.',
    example: 'set_primary_key uid',
  ),
  OpalRef(
    name: 'set_metric',
    category: 'Metadata',
    description:
        'Register a metric with its metadata defined in an options object.',
    example:
        'set_metric options(\n  type: "gauge",\n  description: "CPU usage percent"\n)',
  ),
  OpalRef(
    name: 'interface',
    category: 'Metadata',
    description:
        'Map fields of this dataset to a pre-defined interface.',
    example: 'interface "metric", metric:@.metric_name, value:@.value',
  ),
  OpalRef(
    name: 'sort',
    category: 'Metadata',
    description:
        'Sort rows based on ordering functions applied to column fields.',
    example: 'sort desc(error_count), asc(service)',
  ),
  OpalRef(
    name: 'timeshift',
    category: 'Temporal',
    description:
        'Shifts each row forward or backward in time by adding a duration to the valid-from timestamp.',
    example: 'timeshift 7d',
  ),
  OpalRef(
    name: 'timewrap',
    category: 'Temporal',
    description:
        'Replicates the input N times along a timeline, shifting each copy by multiples of a fixed duration (for comparisons).',
    example: 'timewrap 1w',
  ),
  OpalRef(
    name: 'update_resource',
    category: 'Join',
    description:
        'Builds new columns on a Resource dataset by matching each resource row to Event rows.',
    example:
        'update_resource uid = @"Pod Events".pod_uid,\n  last_event:@"Pod Events".message',
  ),
];

final List<OpalRef> opalFunctions = [
  OpalRef(
    name: 'count',
    category: 'Aggregate',
    description: 'Returns the number of rows in the group.',
    example: 'statsby total:count(1), group_by(service)',
  ),
  OpalRef(
    name: 'count_distinct',
    category: 'Aggregate',
    description: 'Returns the exact number of distinct values.',
    example: 'statsby users:count_distinct(user_id), group_by(service)',
  ),
  OpalRef(
    name: 'count_distinct_approx',
    category: 'Aggregate',
    description:
        'Returns an approximate number of distinct values (faster for large datasets).',
    example:
        'statsby users:count_distinct_approx(user_id), group_by(service)',
  ),
  OpalRef(
    name: 'count_if',
    category: 'Aggregate',
    description: 'Counts rows where the condition is true.',
    example: 'align 1m, errors:count_if(status >= 400), group_by(endpoint)',
  ),
  OpalRef(
    name: 'sum',
    category: 'Aggregate',
    description: 'Returns the sum of all non-null values.',
    example: 'statsby total_bytes:sum(bytes_sent), group_by(service)',
  ),
  OpalRef(
    name: 'avg',
    category: 'Aggregate',
    description: 'Returns the arithmetic mean of all non-null values.',
    example: 'statsby avg_latency:avg(response_ms), group_by(endpoint)',
  ),
  OpalRef(
    name: 'min',
    category: 'Aggregate',
    description: 'Returns the minimum value.',
    example: 'statsby min_latency:min(response_ms), group_by(service)',
  ),
  OpalRef(
    name: 'max',
    category: 'Aggregate',
    description: 'Returns the maximum value.',
    example: 'statsby peak_cpu:max(cpu_percent), group_by(host)',
  ),
  OpalRef(
    name: 'percentile',
    category: 'Aggregate',
    description: 'Returns the value at the given percentile (0-100).',
    example: 'align 1m, p99:percentile(latency_ms, 99), group_by(service)',
  ),
  OpalRef(
    name: 'rate',
    category: 'Aggregate',
    description:
        'Computes the per-second rate of change of a counter metric.',
    example: 'align 5m, rps:rate(value), group_by(service, endpoint)',
  ),
  OpalRef(
    name: 'stddev',
    category: 'Aggregate',
    description: 'Returns the standard deviation of values.',
    example: 'statsby std:stddev(latency_ms), group_by(service)',
  ),
  OpalRef(
    name: 'any',
    category: 'Aggregate',
    description:
        'Returns one arbitrary value from the group (non-deterministic).',
    example: 'statsby sample_host:any(host), group_by(service)',
  ),
  OpalRef(
    name: 'any_not_null',
    category: 'Aggregate',
    description: 'Like any() but ignores null values.',
    example: 'statsby region:any_not_null(region), group_by(service)',
  ),
  OpalRef(
    name: 'any_last',
    category: 'Aggregate',
    description: 'Returns the last (most recent) value from the group.',
    example: 'statsby last_status:any_last(status), group_by(pod)',
  ),
  OpalRef(
    name: 'array_agg',
    category: 'Aggregate',
    description: 'Returns an array of all values in the group.',
    example: 'statsby all_hosts:array_agg(host), group_by(service)',
  ),
  OpalRef(
    name: 'object_agg',
    category: 'Aggregate',
    description:
        'Extracts aggregated fields and values from a group of rows into a new JSON object.',
    example: 'statsby labels:object_agg(key, value), group_by(metric_name)',
  ),
  OpalRef(
    name: 'string',
    category: 'Scalar / Type',
    description: 'Cast a value to string type.',
    example: 'make_col service:string(FIELDS.service)',
  ),
  OpalRef(
    name: 'int64',
    category: 'Scalar / Type',
    description: 'Cast a value to 64-bit integer.',
    example: 'make_col status_code:int64(status)',
  ),
  OpalRef(
    name: 'float64',
    category: 'Scalar / Type',
    description: 'Cast a value to 64-bit floating point.',
    example: 'make_col latency_ms:float64(duration_ns) / 1000000.0',
  ),
  OpalRef(
    name: 'bool',
    category: 'Scalar / Type',
    description: 'Cast a value to boolean.',
    example: 'make_col is_active:bool(status_field)',
  ),
  OpalRef(
    name: 'parse_json',
    category: 'Scalar / Parse',
    description: 'Parse a JSON string into a structured object.',
    example: 'make_col parsed:parse_json(string(FIELDS))',
  ),
  OpalRef(
    name: 'parse_csv',
    category: 'Scalar / Parse',
    description:
        'Parses an input string as character-separated values.',
    example: 'make_col fields:parse_csv(message, ",")',
  ),
  OpalRef(
    name: 'parse_ip',
    category: 'Scalar / Parse',
    description: 'Parse an IPv4 or IPv6 network address into attributes.',
    example: 'make_col ip_info:parse_ip(source_ip)',
  ),
  OpalRef(
    name: 'parse_kvs',
    category: 'Scalar / Parse',
    description:
        'Returns an object of key=value pairs extracted from a string.',
    example: 'make_col kv:parse_kvs(query_string)',
  ),
  OpalRef(
    name: 'parse_url',
    category: 'Scalar / Parse',
    description: 'Parses a URL string into its component parts.',
    example: 'make_col url_parts:parse_url(request_url)',
  ),
  OpalRef(
    name: 'concat',
    category: 'Scalar / String',
    description: 'Concatenates two or more strings.',
    example: 'make_col endpoint:concat(method, " ", path)',
  ),
  OpalRef(
    name: 'substring',
    category: 'Scalar / String',
    description: 'Extracts a substring by position and length.',
    example: 'make_col status_class:substring(string(status_code), 1, 1)',
  ),
  OpalRef(
    name: 'lower',
    category: 'Scalar / String',
    description: 'Converts a string to lowercase.',
    example: 'make_col service_lower:lower(service)',
  ),
  OpalRef(
    name: 'upper',
    category: 'Scalar / String',
    description: 'Converts a string to uppercase.',
    example: 'make_col severity_upper:upper(severity)',
  ),
  OpalRef(
    name: 'trim',
    category: 'Scalar / String',
    description: 'Removes leading and trailing whitespace.',
    example: 'make_col clean_msg:trim(message)',
  ),
  OpalRef(
    name: 'replace',
    category: 'Scalar / String',
    description: 'Replaces occurrences of a pattern in a string.',
    example: 'make_col cleaned:replace(message, "\\n", " ")',
  ),
  OpalRef(
    name: 'split',
    category: 'Scalar / String',
    description: 'Splits a string into an array by a delimiter.',
    example: 'make_col parts:split(path, "/")',
  ),
  OpalRef(
    name: 'strlen',
    category: 'Scalar / String',
    description: 'Returns the length of a string in characters.',
    example: 'make_col msg_len:strlen(message)',
  ),
  OpalRef(
    name: 'contains',
    category: 'Scalar / String',
    description: 'Returns true if a string contains the given substring.',
    example: 'filter contains(message, "timeout")',
  ),
  OpalRef(
    name: 'starts_with',
    category: 'Scalar / String',
    description: 'Returns true if a string starts with the given prefix.',
    example: 'filter starts_with(path, "/api/v2")',
  ),
  OpalRef(
    name: 'ends_with',
    category: 'Scalar / String',
    description: 'Returns true if a string ends with the given suffix.',
    example: 'filter ends_with(host, ".internal")',
  ),
  OpalRef(
    name: 'match_regex',
    category: 'Scalar / String',
    description: 'Returns true if a string matches the regex pattern.',
    example: 'filter match_regex(message, /error|fail|timeout/i)',
  ),
  OpalRef(
    name: 'regex',
    category: 'Scalar / String',
    description: 'Extracts the first regex match from a string.',
    example: 'make_col trace_id:regex(message, /trace_id=([a-f0-9]+)/)',
  ),
  OpalRef(
    name: 'abs',
    category: 'Scalar / Math',
    description: 'Returns the absolute value.',
    example: 'make_col deviation:abs(current - baseline)',
  ),
  OpalRef(
    name: 'round',
    category: 'Scalar / Math',
    description: 'Rounds a number to the specified decimal places.',
    example: 'make_col latency:round(latency_ms, 2)',
  ),
  OpalRef(
    name: 'pow',
    category: 'Scalar / Math',
    description: 'Returns base raised to the power of exponent.',
    example: 'make_col squared:pow(value, 2)',
  ),
  OpalRef(
    name: 'log',
    category: 'Scalar / Math',
    description: 'Returns the natural logarithm.',
    example: 'make_col log_value:log(request_count)',
  ),
  OpalRef(
    name: 'ceil',
    category: 'Scalar / Math',
    description: 'Rounds up to the nearest integer.',
    example: 'make_col bucket:ceil(latency_ms / 100.0) * 100',
  ),
  OpalRef(
    name: 'floor',
    category: 'Scalar / Math',
    description: 'Rounds down to the nearest integer.',
    example: 'make_col bucket:floor(latency_ms / 100.0) * 100',
  ),
  OpalRef(
    name: 'if_else',
    category: 'Scalar / Logic',
    description:
        'Returns one of two values based on a boolean condition.',
    example:
        'make_col severity_label:if_else(status >= 500, "critical", "warning")',
  ),
  OpalRef(
    name: 'coalesce',
    category: 'Scalar / Logic',
    description: 'Returns the first non-null argument.',
    example: 'make_col name:coalesce(display_name, hostname, "unknown")',
  ),
  OpalRef(
    name: 'is_null',
    category: 'Scalar / Logic',
    description: 'Returns true if the value is null.',
    example: 'filter is_null(error_message)',
  ),
  OpalRef(
    name: 'is_not_null',
    category: 'Scalar / Logic',
    description: 'Returns true if the value is not null.',
    example: 'filter is_not_null(trace_id)',
  ),
  OpalRef(
    name: 'now',
    category: 'Scalar / Temporal',
    description: 'Returns the current wall-clock time.',
    example: 'make_col age:now() - timestamp',
  ),
  OpalRef(
    name: 'timestamp_ns',
    category: 'Scalar / Temporal',
    description: 'Creates a timestamp from nanoseconds since epoch.',
    example: 'make_col ts:timestamp_ns(epoch_ns)',
  ),
  OpalRef(
    name: 'duration',
    category: 'Scalar / Temporal',
    description: 'Creates a duration value from a numeric and unit.',
    example: 'make_col timeout:duration(30, "s")',
  ),
  OpalRef(
    name: 'bin',
    category: 'Scalar / Temporal',
    description: 'Truncates a timestamp to a given time bucket.',
    example: 'make_col hour:bin(timestamp, 1h)',
  ),
  OpalRef(
    name: 'row_number',
    category: 'Window',
    description:
        'Assigns a sequential number to each row within a partition.',
    example:
        'make_col rn:row_number(), frame(partition_by: [service], order_by: [desc(timestamp)])',
  ),
  OpalRef(
    name: 'rank',
    category: 'Window',
    description:
        'Assigns a rank based on ordering, with ties getting the same rank.',
    example:
        'make_col r:rank(), frame(partition_by: [service], order_by: [desc(error_count)])',
  ),
  OpalRef(
    name: 'lag',
    category: 'Window',
    description: 'Returns the value from a previous row in the partition.',
    example: 'make_col prev_value:lag(value, 1)',
  ),
  OpalRef(
    name: 'lead',
    category: 'Window',
    description: 'Returns the value from a following row in the partition.',
    example: 'make_col next_value:lead(value, 1)',
  ),
  OpalRef(
    name: 'window',
    category: 'Window',
    description:
        'Applies an aggregate function over a sliding window frame.',
    example:
        'make_col rolling_avg:window(avg(value), frame(rows: -12, 0))',
  ),
  OpalRef(
    name: 'object',
    category: 'Scalar / Object',
    description: 'Convert a datum into an object (or null if impossible).',
    example: 'make_col metadata:object(FIELDS)',
  ),
  OpalRef(
    name: 'object_keys',
    category: 'Scalar / Object',
    description: 'Get an array of top-level keys from an object field.',
    example: 'make_col keys:object_keys(labels)',
  ),
  OpalRef(
    name: 'merge_objects',
    category: 'Scalar / Object',
    description: 'Merge one or more objects into a single object.',
    example: 'make_col combined:merge_objects(labels, annotations)',
  ),
  OpalRef(
    name: 'array_length',
    category: 'Scalar / Object',
    description: 'Returns the number of elements in an array.',
    example: 'make_col tag_count:array_length(tags)',
  ),
];
