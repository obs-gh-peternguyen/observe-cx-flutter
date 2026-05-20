import 'package:flutter/material.dart';

class OpalSyntaxHighlighter {
  static const _verbs = {
    'filter', 'make_col', 'pick_col', 'statsby', 'sort', 'timechart',
    'topk', 'bottomk', 'leftjoin', 'join', 'fulljoin', 'union', 'lookup',
    'extract_regex', 'flatten', 'flatten_all', 'flatten_leaves',
    'flatten_single', 'align', 'timeshift', 'timewrap', 'follow',
    'follow_not', 'make_resource', 'make_event', 'make_interval',
    'make_session', 'make_table', 'make_metric', 'make_reference',
    'set_label', 'set_link', 'set_primary_key', 'set_metric',
    'set_metric_metadata', 'set_pk', 'set_timestamp', 'set_valid_from',
    'set_valid_to', 'interface', 'drop_col', 'rename_col', 'limit',
    'dedup', 'distinct', 'histogram', 'pivot', 'unpivot', 'rollup',
    'timestats', 'aggregate', 'fill', 'exists', 'not_exists',
    'surrounding', 'update_resource', 'ever', 'never', 'always',
    'merge_events', 'filter_last',
  };

  static const _functions = {
    'count', 'count_distinct', 'count_distinct_approx', 'count_if',
    'sum', 'avg', 'min', 'max', 'percentile', 'rate',
    'float64', 'int64', 'string', 'bool', 'parse_json', 'parse_csv',
    'parse_ip', 'parse_kvs', 'parse_url', 'concat', 'substring',
    'lower', 'upper', 'trim', 'replace', 'split', 'strlen',
    'contains', 'starts_with', 'ends_with', 'match_regex', 'regex',
    'abs', 'round', 'pow', 'log', 'ceil', 'floor',
    'if_else', 'coalesce', 'is_null', 'is_not_null',
    'now', 'timestamp_ns', 'duration', 'bin',
    'row_number', 'rank', 'lag', 'lead', 'window',
    'object', 'object_keys', 'merge_objects', 'array_agg',
    'array_agg_distinct', 'array_length', 'object_agg',
    'any', 'any_not_null', 'any_last', 'stddev',
    'desc', 'asc', 'group_by', 'options', 'primarykey', 'frame',
    'session_key',
  };

  static const _keywords = {
    'true', 'false', 'null', 'and', 'or', 'not', 'in',
  };

  static Widget buildHighlightedCode(String code) {
    final lines = code.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) => _buildHighlightedLine(line)).toList(),
    );
  }

  static Widget _buildHighlightedLine(String line) {
    final spans = <TextSpan>[];
    final trimmedLine = line.trimLeft();
    final indent = line.length - trimmedLine.length;

    if (indent > 0) {
      spans.add(TextSpan(
        text: ' ' * indent,
        style: const TextStyle(fontFamily: 'monospace'),
      ));
    }

    if (trimmedLine.startsWith('//')) {
      spans.add(TextSpan(
        text: trimmedLine,
        style: const TextStyle(
          color: Color(0xFF6A9955),
          fontFamily: 'monospace',
          fontSize: 13,
        ),
      ));
    } else {
      final tokens = RegExp(r'\S+|\s+').allMatches(trimmedLine);
      for (final match in tokens) {
        final token = match.group(0)!;
        if (token.trim().isEmpty) {
          spans.add(TextSpan(
            text: token,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          ));
        } else {
          spans.add(_colorWord(token));
        }
      }
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  static TextSpan _colorWord(String word) {
    final cleanWord = word.replaceAll(RegExp(r'[^a-zA-Z_]'), '');

    if (_verbs.contains(cleanWord)) {
      return TextSpan(
        text: word,
        style: const TextStyle(
          color: Color(0xFF569CD6),
          fontFamily: 'monospace',
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (_functions.contains(cleanWord)) {
      return TextSpan(
        text: word,
        style: const TextStyle(
          color: Color(0xFFDCDCAA),
          fontFamily: 'monospace',
          fontSize: 13,
        ),
      );
    } else if (_keywords.contains(cleanWord)) {
      return TextSpan(
        text: word,
        style: const TextStyle(
          color: Color(0xFF4EC9B0),
          fontFamily: 'monospace',
          fontSize: 13,
        ),
      );
    } else if (RegExp(r'^".*"$').hasMatch(word) ||
        RegExp(r'^"').hasMatch(word) ||
        RegExp(r'"$').hasMatch(word)) {
      return TextSpan(
        text: word,
        style: const TextStyle(
          color: Color(0xFFCE9178),
          fontFamily: 'monospace',
          fontSize: 13,
        ),
      );
    } else if (RegExp(r'^\d').hasMatch(word)) {
      return TextSpan(
        text: word,
        style: const TextStyle(
          color: Color(0xFFB5CEA8),
          fontFamily: 'monospace',
          fontSize: 13,
        ),
      );
    } else if (word.contains('@')) {
      return TextSpan(
        text: word,
        style: const TextStyle(
          color: Color(0xFFC586C0),
          fontFamily: 'monospace',
          fontSize: 13,
        ),
      );
    } else if (word.contains(':') && !word.startsWith(':')) {
      return TextSpan(
        text: word,
        style: const TextStyle(
          color: Color(0xFF9CDCFE),
          fontFamily: 'monospace',
          fontSize: 13,
        ),
      );
    }

    return TextSpan(
      text: word,
      style: const TextStyle(
        color: Color(0xFFD4D4D4),
        fontFamily: 'monospace',
        fontSize: 13,
      ),
    );
  }
}
