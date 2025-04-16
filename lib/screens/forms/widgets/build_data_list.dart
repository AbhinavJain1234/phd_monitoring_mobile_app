import 'package:flutter/material.dart';

Widget buildDataList(List<String> faculty) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: faculty.length,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text(
          '${index + 1}. ${faculty[index]}',
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        contentPadding: EdgeInsets.zero,
      );
    },
  );
}
