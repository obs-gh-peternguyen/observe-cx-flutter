import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/opal_examples.dart';
import '../widgets/opal_syntax_highlighter.dart';
import 'opal_reference_page.dart';

class OpalPage extends StatelessWidget {
  const OpalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ...opalLevels.map((level) => Tab(text: level.id)),
      const Tab(text: 'Ref'),
    ];

    return DefaultTabController(
      length: opalLevels.length + 1,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: TabBar(
              isScrollable: true,
              tabs: tabs,
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                ...opalLevels.map((level) => _LevelContent(level: level)),
                const OpalReferencePage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelContent extends StatelessWidget {
  final OpalLevel level;

  const _LevelContent({required this.level});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          level.name,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          level.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        ...level.examples.map((example) => _ExampleCard(example: example)),
      ],
    );
  }
}

class _ExampleCard extends StatelessWidget {
  final OpalExample example;

  const _ExampleCard({required this.example});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              example.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              example.scenario,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Source: ${example.sourceDataset}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            _OpalCodeBlock(query: example.query),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.tertiaryContainer,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 18,
                    color: theme.colorScheme.tertiary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      example.tip,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpalCodeBlock extends StatelessWidget {
  final String query;

  const _OpalCodeBlock({required this.query});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2D2D3F),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'OPAL',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: query));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('OPAL query copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.copy, size: 14, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        'Copy',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: OpalSyntaxHighlighter.buildHighlightedCode(query),
          ),
        ],
      ),
    );
  }
}
