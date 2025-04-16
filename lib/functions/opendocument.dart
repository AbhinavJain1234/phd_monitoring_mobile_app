import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phd_monitoring_mobile_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

Future<void> downloadAndOpenPdf(String pdfPath, BuildContext context) async {
  try {
    // Process the path
    int publicIndex = pdfPath.indexOf('/public/');
    String relativePath = '';

    if (publicIndex != -1) {
      relativePath = pdfPath.substring(publicIndex + 8);
    } else {
      relativePath = pdfPath.startsWith('/') ? pdfPath.substring(1) : pdfPath;
    }

    // Construct the URL for the PDF file
    final url = 'https://phdportal.thapar.edu/api/storage/$relativePath';

    // Get the auth token from your UserProvider
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Create headers with the same auth pattern as fetchData
    final headers = {
      'Authorization': 'Bearer ${userProvider.user?.token}',
      'Accept': 'application/pdf', // Request PDF content specifically
    };

    // Make the request directly for binary data
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Get temporary directory to save the file
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/irb_document.pdf';

      // Write the PDF bytes to the file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // Open the PDF file with the default viewer
      final result = await OpenFile.open(filePath);

      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening PDF: ${result.message}')),
        );
      }
    } else {
      // Handle error based on status code, similar to fetchData
      if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unauthorized. Please log in again.')),
        );
        // Navigate to login screen
        Navigator.of(context).pushNamed('/login');
        userProvider.logout(); // Log the user out
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download PDF: ${response.statusCode}'),
          ),
        );
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error processing PDF: $e')));
  }
}
