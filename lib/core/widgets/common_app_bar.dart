import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class CommonAppBar extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onSettings;
  final String? title;
  final Widget? middleContent;
  final bool showSettings;

  const CommonAppBar({
    super.key,
    this.onBack,
    this.onSettings,
    this.title,
    this.middleContent,
    this.showSettings = true,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final appBarHeight = kToolbarHeight;

    return Container(
      height: topPadding + appBarHeight,
      padding: EdgeInsets.only(top: topPadding, left: 16, right: 16),
      color: Colors.transparent, // Allow background to show through
      child: Row(
        children: [
          IconButton(
            // Using standard Icon to match MapScreen exactly, 
            // or HeroIcon if updating everything. User said "match Map Screen",
            // MapScreen uses Icon(Icons.arrow_back).
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onBack ?? () => context.pop(),
          ),
          
          Expanded(
            child: middleContent ?? (title != null 
              ? Center(
                  child: Text(
                    title!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 1),
                          blurRadius: 4.0,
                          color: Colors.black.withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                    ),
                  )
              : const SizedBox.shrink()
            ),
          ),
          
          if (showSettings)
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: onSettings ?? () {
                debugPrint("Settings clicked");
              },
            )
          else
            const SizedBox(width: 48), // Balance the back button spacing
        ],
      ),
    );
  }
}
