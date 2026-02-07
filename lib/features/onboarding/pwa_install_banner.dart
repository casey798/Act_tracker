import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:tracker_pwa/core/theme/app_theme.dart';
import 'package:universal_html/html.dart' as html;

class PwaInstallBanner extends StatefulWidget {
  const PwaInstallBanner({super.key});

  @override
  State<PwaInstallBanner> createState() => _PwaInstallBannerState();
}

class _PwaInstallBannerState extends State<PwaInstallBanner> {
  // Initially visible if conditions are met
  bool _isVisible = true;

  bool get _isStandalone {
    if (!kIsWeb) return true; // Assume standalone if not web
    return html.window.matchMedia('(display-mode: standalone)').matches;
  }

  @override
  Widget build(BuildContext context) {
    // Only show on web, if not standalone, and user hasn't dismissed it
    if (!kIsWeb || _isStandalone || !_isVisible) {
      return const SizedBox.shrink();
    }

    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Install App for Best Experience',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isIOS
                        ? 'Tap "Share" -> "Add to Home Screen"'
                        : 'Tap "Menu" -> "Install App"',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _isVisible = false;
                });
              },
              icon: const Icon(Icons.close, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
