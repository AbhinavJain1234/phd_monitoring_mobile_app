import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phd_monitoring_mobile_app/constants/url.dart';
import 'package:phd_monitoring_mobile_app/functions/fetch_data.dart';
import 'package:phd_monitoring_mobile_app/theme/app_colors.dart';
class PublicationsScreen extends StatefulWidget {
  const PublicationsScreen({super.key});

  @override
  State<PublicationsScreen> createState() => _PublicationsScreenState();
}

class _PublicationsScreenState extends State<PublicationsScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _publicationData = {};

  @override
  void initState() {
    super.initState();
    _fetchPublications();
  }

  Future<void> _fetchPublications() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final response = await fetchData(
        url: '$SERVER_URL/publications',
        context: context,
      );
      print("response: $response");

      if (mounted && response['success']) {
        setState(() {
          _publicationData = response['response'];
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Publications',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(),
            labelColor: Colors.white,
            unselectedLabelColor: const Color.fromARGB(255, 255, 114, 114),
            tabs: const [
              Tab(text: 'SCI/SCIE/SSCI/ABCD/AHCl Journal'),
              Tab(text: 'Scopus Journal'),
              Tab(text: 'Book Chapters'),
              Tab(text: 'International Conference'),
              Tab(text: 'National Conference'),
              Tab(text: 'Patents'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _fetchPublications,
                child: TabBarView(
                  children: [
                    _buildPublicationList('sci'),
                    _buildPublicationList('non_sci'),
                    _buildPublicationList('book'),
                    _buildPublicationList('international'),
                    _buildPublicationList('national'),
                    _buildPublicationList('patents'),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildPublicationList(String type) {
    final data = _publicationData[type] ?? [];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.isEmpty ? 1 : data.length,
      itemBuilder: (context, index) {
        if (data.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.3),
              child: Text(
                'No publications found',
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }

        final publication = data[index];
        return _PublicationCard(publication: publication);
      },
    );
  }
}

class _PublicationCard extends StatelessWidget {
  final Map<String, dynamic> publication;

  const _PublicationCard({required this.publication});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              publication['title'] ?? 'Untitled',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    (publication['authors'] as String?)
                            ?.split(';')
                            .join(', ') ??
                        'Unknown Authors',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildChip(
                  Icons.calendar_today,
                  _formatDate(publication['year']),
                ),
                if (publication['volume'] != null) ...[
                  const SizedBox(width: 8),
                  _buildChip(
                    Icons.book,
                    'Vol. ${publication['volume']}',
                  ),
                ],
                if (publication['impact_factor'] != null) ...[
                  const SizedBox(width: 8),
                  _buildChip(
                    Icons.star,
                    'IF: ${publication['impact_factor']}',
                  ),
                ],
                const Spacer(),
                _buildStatusChip(publication['status'] ?? 'N/A'),
              ],
            ),
            if (publication['doi_link'] != null ||
                publication['first_page'] != null)
              const Divider(height: 24),
            if (publication['doi_link'] != null ||
                publication['first_page'] != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (publication['doi_link'] != null)
                    TextButton.icon(
                      onPressed: () {
                        // Open DOI link
                      },
                      icon: const Icon(Icons.link, size: 18),
                      label: const Text('DOI'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                  if (publication['first_page'] != null)
                    TextButton.icon(
                      onPressed: () {
                        // View publication file
                      },
                      icon: const Icon(Icons.visibility, size: 18),
                      label: const Text('View'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final isAccepted = status.toLowerCase() == 'accepted';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isAccepted ? Colors.green : Colors.orange).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.poppins(
          color: isAccepted ? Colors.green : Colors.orange,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }
}
