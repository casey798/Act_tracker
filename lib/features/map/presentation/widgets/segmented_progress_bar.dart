import 'package:flutter/material.dart';

class SegmentedProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const SegmentedProgressBar({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalSteps, (index) {

        // The user spec says:
        // Active State (Current Step): White, Glow
        // Inactive State (Future/Past Steps): Grey[800] or White with 0.2 opacity.
        // Usually "Active State" implies only the current one, but often progress bars fill up.
        // "Active State (Current Step)" vs "Inactive State (Future/Past Steps)".
        // If I interpret "Active State (Current Step)" strictly, only the segment *currently being filled* is active?
        // But usually progress bars fill up. "Logic: The widget should accept an integer currentStep (0-3) to determine which segment gets the 'Active' glow styling."
        // Let's assume it's a progress indicator where steps <= currentStep are "filled" or "active".
        // Wait, the spec says "Active State (Current Step)". And "Inactive State (Future/Past Steps)".
        // If it's a progress bar, past steps should be filled.
        // Let's interpret "Active" as "Filled/Completed or Current".
        // Actually, looking at the user request: "The widget should accept an integer currentStep (0-3) to determine which segment gets the 'Active' glow styling."
        // It's likely a charging meter filling up. So 0->1->2->3.
        // If currentStep is 0 (first segment), it should be glowing? Or just filling?
        // The `AnimationController` goes from 0.0 to 1.0.
        // We map that to 0, 1, 2, 3.
        // So if we are at step 2, segments 0, 1, 2 should probably be "Active"?
        // Or just the tip?
        // "Active State (Current Step)" suggests the specific segment corresponding to the step.
        // "Inactive State (Future/Past Steps)". This implies ONLY the current one is active?
        // But it's a "Progress Bar". Progress bars usually accumulate.
        // Let's stick to standard progress bar behavior: Filled segments are White. Unfilled are Grey.
        // And maybe the *current* one (the latest filled one) has the Glow?
        // Re-reading: "Active State (Current Step) ... Inactive State (Future/Past Steps)".
        // "Inactive State (Future/Past Steps)" - this phrasing is slightly ambiguous. "Past Steps" being inactive suggests they turn off?
        // Use case: Long press to fill up a meter.
        // If I hold it, it fills 1, then 2, then 3, then 4.
        // If it's a "Segmented Progress Bar", usually you want to see how much progress you have made.
        // So steps 0..currentStep should probably be colored White.
        // But if spec says "Inactive State (Future/Past Steps)" maybe it really means a single traveling light?
        // "Segmented Progress Bar to replace the standard linear progress indicator".
        // Standard linear indicator fills up.
        // So I will assume "Active" applies to all segments <= currentStep, OR "Active" is just the current head, and "Past" are also filled but maybe different?
        // Let's look at "Inactive State (Future/Past Steps)".
        // If Past Steps are Inactive, then they are Grey. That would mean it's a traveling dot.
        // But it's a "Progress Bar".
        // Let's try to interpret "Current Step" as the index.
        // If index == currentStep, it's Active (White + Glow).
        // If index < currentStep (Past), it's probably completed. Usually completed steps are solid color (White) but maybe no glow?
        // The spec only defined "Active State (Current Step)" and "Inactive State (Future/Past Steps)".
        // It didn't explicitly define "Completed State".
        // If I rigidly follow "Inactive State (Future/Past Steps)", then Past steps are Grey.
        // That makes it a single loading indicator that jumps.
        // That seems unlikely for a "Progress Bar".
        // However, user said "replace the standard linear progress indicator".
        // I will assume Past steps should be White (filled) but maybe no glow?
        // OR, simply: "Active" = index <= currentStep.
        // "Inactive" = index > currentStep.
        // Let's assume index <= currentStep is Active.
        
        final bool isFilled = index <= currentStep;
        
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < totalSteps - 1 ? 8.0 : 0.0),
            height: 6,
            decoration: BoxDecoration(
              color: isFilled ? Colors.white : Colors.grey[800],
              borderRadius: BorderRadius.circular(3), // Fully rounded (height/2)
              boxShadow: isFilled
                  ? [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ]
                  : null,
            ),
          ),
        );
      }),
    );
  }
}
