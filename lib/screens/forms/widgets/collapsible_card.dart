import 'package:flutter/material.dart';

class CollapsibleCard extends StatefulWidget {
  final String title;
  final Widget content;
  final bool isAlwaysExpanded;

  const CollapsibleCard({
    super.key,
    required this.title,
    required this.content,
    this.isAlwaysExpanded = false,
  });

  @override
  State<CollapsibleCard> createState() => _CollapsibleCardState();
}

class _CollapsibleCardState extends State<CollapsibleCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap:
                widget.isAlwaysExpanded
                    ? null
                    : () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(12),
                  bottom:
                      (widget.isAlwaysExpanded || _isExpanded)
                          ? Radius.zero
                          : const Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  if (!widget.isAlwaysExpanded)
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                ],
              ),
            ),
          ),
          if (widget.isAlwaysExpanded || _isExpanded)
            Padding(padding: const EdgeInsets.all(16), child: widget.content),
        ],
      ),
    );
  }
}
