import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/opal_reference.dart';
import '../widgets/opal_syntax_highlighter.dart';

class OpalReferencePage extends StatefulWidget {
  const OpalReferencePage({super.key});

  @override
  State<OpalReferencePage> createState() => _OpalReferencePageState();
}

class _OpalReferencePageState extends State<OpalReferencePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search verbs & functions...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
        ),
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Verbs'),
            Tab(text: 'Functions'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _RefList(items: _filteredVerbs),
              _RefList(items: _filteredFunctions),
            ],
          ),
        ),
      ],
    );
  }

  List<OpalRef> get _filteredVerbs {
    if (_searchQuery.isEmpty) return opalVerbs;
    return opalVerbs
        .where((r) =>
            r.name.toLowerCase().contains(_searchQuery) ||
            r.description.toLowerCase().contains(_searchQuery) ||
            r.category.toLowerCase().contains(_searchQuery))
        .toList();
  }

  List<OpalRef> get _filteredFunctions {
    if (_searchQuery.isEmpty) return opalFunctions;
    return opalFunctions
        .where((r) =>
            r.name.toLowerCase().contains(_searchQuery) ||
            r.description.toLowerCase().contains(_searchQuery) ||
            r.category.toLowerCase().contains(_searchQuery))
        .toList();
  }
}

class _RefList extends StatelessWidget {
  final List<OpalRef> items;

  const _RefList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No results found.'));
    }

    final grouped = <String, List<OpalRef>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: grouped.entries.expand((entry) {
        return [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4, left: 4),
            child: Text(
              entry.key,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          ...entry.value.map((ref) => _RefTile(ref: ref)),
        ];
      }).toList(),
    );
  }
}

class _RefTile extends StatelessWidget {
  final OpalRef ref;

  const _RefTile({required this.ref});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: ExpansionTile(
        title: Text(
          ref.name,
          style: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          ref.description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: OpalSyntaxHighlighter.buildHighlightedCode(ref.example),
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: ref.example));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Example copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Icon(Icons.copy, size: 16, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
