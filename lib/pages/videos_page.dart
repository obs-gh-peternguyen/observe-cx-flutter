import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/videos_data.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  String _searchQuery = '';
  String? _selectedTopic;

  List<VideoEntry> get _filteredVideos {
    var videos = allVideos;
    if (_selectedTopic != null) {
      videos = videos
          .where((v) => v.topics.contains(_selectedTopic))
          .toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      videos = videos
          .where((v) =>
              v.title.toLowerCase().contains(q) ||
              v.topics.any((t) => t.toLowerCase().contains(q)) ||
              v.notes.toLowerCase().contains(q))
          .toList();
    }
    return videos;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final filtered = _filteredVideos;

    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search videos...',
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
                  _searchQuery = value;
                });
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _TopicChip(
                label: 'All',
                selected: _selectedTopic == null,
                onTap: () => setState(() => _selectedTopic = null),
              ),
              ...allTopics.map((topic) => _TopicChip(
                    label: topic,
                    selected: _selectedTopic == topic,
                    onTap: () => setState(() {
                      _selectedTopic = _selectedTopic == topic ? null : topic;
                    }),
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '${filtered.length} video${filtered.length == 1 ? '' : 's'}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: filtered.length,
            itemBuilder: (context, index) =>
                _VideoTile(video: filtered[index]),
          ),
        ),
      ],
    );
  }
}

class _TopicChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TopicChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

class _VideoTile extends StatelessWidget {
  final VideoEntry video;

  const _VideoTile({required this.video});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          video.title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(Icons.schedule, size: 14, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(
              video.length,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              video.publishedDate,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: video.topics.map((topic) {
                    return Chip(
                      label: Text(topic),
                      labelStyle: const TextStyle(fontSize: 11),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
                if (video.notes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    video.notes,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: _YouTubeEmbed(videoId: video.youtubeId, url: video.url),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _YouTubeEmbed extends StatelessWidget {
  final String videoId;
  final String url;

  const _YouTubeEmbed({required this.videoId, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 200,
              color: Colors.black,
              child: const Center(
                child: Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.play_arrow,
              size: 48,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
