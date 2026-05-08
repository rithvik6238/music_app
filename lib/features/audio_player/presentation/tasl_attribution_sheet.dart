import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:url_launcher/url_launcher.dart';

class TaslAttributionSheet extends StatelessWidget {
  final MediaItem mediaItem;

  const TaslAttributionSheet({super.key, required this.mediaItem});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = mediaItem.title;
    final author = mediaItem.artist ?? 'Unknown Artist';
    final source = 'Jamendo';
    final licenseUrl = mediaItem.extras?['license_ccurl'] as String? ?? 'https://creativecommons.org/licenses/by/3.0/';

    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Track Attribution (TASL)',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildRichText('Title: ', title),
          const SizedBox(height: 8),
          _buildRichText('Author: ', author),
          const SizedBox(height: 8),
          _buildRichText('Source: ', source),
          const SizedBox(height: 16),
          const Text('License:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 4),
          InkWell(
            onTap: () => _launchUrl(licenseUrl),
            child: Text(
              licenseUrl,
              style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '"$title" by $author is licensed under CC BY 3.0',
            style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white70),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRichText(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16, color: Colors.white),
        children: [
          TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
