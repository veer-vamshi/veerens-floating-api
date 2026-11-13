import 'package:flutter/material.dart';

/// A titled, bordered dark card used to group a piece of the API detail
/// view (headers / query / body / etc).
class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.title, required this.child, this.actions});

  final String title;
  final Widget child;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              ?actions,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
