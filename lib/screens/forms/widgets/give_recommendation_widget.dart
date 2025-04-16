import 'package:flutter/material.dart';
import 'package:phd_monitoring_mobile_app/constants/url.dart';
import 'package:phd_monitoring_mobile_app/functions/fetch_data.dart';
import 'package:phd_monitoring_mobile_app/screens/forms/widgets/collapsible_card.dart';

//what is the payload
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
  bool isRecommended = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController commentController =
        TextEditingController(); // Initialize the controller
    return StatefulBuilder(
      builder: (context, setState) {
        // Default to Not Recommended

        return CollapsibleCard(
          title: 'Your Recommendation',
          isAlwaysExpanded: true,
          content: Column(
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
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => isRecommended = true);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.green),
                        backgroundColor:
                            isRecommended
                                ? Colors.green.withOpacity(0.1)
                                : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Recommend',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => isRecommended = false);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.red),
                        backgroundColor:
                            !isRecommended ? Colors.red.withOpacity(0.1) : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Not Recommended',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Comments',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                maxLines: 4,
                controller: commentController,
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
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // If not recommended and comment is empty
                    if (!isRecommended &&
                        commentController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please provide comments when not recommending.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return; // Don't proceed
                    }

                    final response = await fetchData(
                      url:
                          '$SERVER_URL/forms/${widget.formType}/${widget.formId}',
                      method: 'POST',
                      body: {
                        'approval': isRecommended,
                        'comments': commentController.text.trim(),
                        'rejection': false,
                      },
                      context: context,
                    );

                    if (response['success']) {
                      print('Allocation updated successfully.');
                      widget.onSubmit();
                    } else {
                      print(
                        'Failed to update allocation: ${response['response']}',
                      );
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Recommendation submitted'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Submit Recommendation',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
