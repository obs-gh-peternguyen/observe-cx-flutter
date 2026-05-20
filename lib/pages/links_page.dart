import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/links_data.dart';

class LinksPage extends StatelessWidget {
  const LinksPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Useful Links',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...usefulLinks.map((link) => _LinkTile(link: link)),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final UsefulLink link;

  const _LinkTile({required this.link});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.link, color: theme.colorScheme.primary),
        title: Text(
          link.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.primary,
          ),
        ),
        subtitle: Text(link.description),
        trailing: const Icon(Icons.open_in_new, size: 18),
        onTap: () => launchUrl(Uri.parse(link.url)),
      ),
    );
  }
}
