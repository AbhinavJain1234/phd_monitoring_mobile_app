import 'package:flutter/material.dart';
import 'package:phd_monitoring_mobile_app/constants/url.dart';
import 'package:phd_monitoring_mobile_app/functions/fetch_data.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/collapsible_card.dart';

class GiveRecommendationWidget extends StatefulWidget {
  final String postition;
  final String formType;
  final String formId;
  final VoidCallback onSubmit;

  const GiveRecommendationWidget({
    super.key,
    required this.postition,
    required this.formType,
    required this.formId,
    required this.onSubmit,
  });

  @override
  State<GiveRecommendationWidget> createState() =>
      _GiveRecommendationWidgetState();
}

class _GiveRecommendationWidgetState extends State<GiveRecommendationWidget> {
  late final TextEditingController _commentController;
  bool _isRecommended = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitRecommendation() async {
    // Validation
    if (!_isRecommended && _commentController.text.trim().isEmpty) {
      _showSnackBar(
        'Please provide comments when not recommending.',
        isError: true,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final response = await fetchData(
        url: '$SERVER_URL/forms/${widget.formType}/${widget.formId}',
        method: 'POST',
        body: {
          'approval': _isRecommended,
          'comments': _commentController.text.trim(),
          'rejection': false,
          'rejected': _isRecommended ? false : true,
        },
        context: context,
      );

      if (!mounted) return;

      if (response['success']) {
        _showSnackBar('Recommendation submitted successfully!');
        // Delay to let user see the success message
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          widget.onSubmit();
        }
      } else {
        _showSnackBar(
          'Failed: ${response['message'] ?? 'Unknown error'}',
          isError: true,
        );
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CollapsibleCard(
      title: 'Your Recommendation',
      isAlwaysExpanded: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDecisionButtons(),
          const SizedBox(height: 20),
          _buildCommentsSection(),
          const SizedBox(height: 16),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildDecisionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Decision',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDecisionButton(
                label: 'Recommend',
                isSelected: _isRecommended,
                color: Colors.green,
                onPressed: () => setState(() => _isRecommended = true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDecisionButton(
                label: 'Not Recommended',
                isSelected: !_isRecommended,
                color: Colors.red,
                onPressed: () => setState(() => _isRecommended = false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDecisionButton({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: color),
        backgroundColor: isSelected ? color.withOpacity(0.1) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comments',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: 4,
          controller: _commentController,
          enabled: !_isSubmitting,
          decoration: InputDecoration(
            hintText: 'Enter your comments here...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitRecommendation,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          disabledBackgroundColor: Colors.grey[400],
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Submit Recommendation',
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
