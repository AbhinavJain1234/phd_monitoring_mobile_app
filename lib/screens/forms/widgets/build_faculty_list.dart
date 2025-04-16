import 'package:flutter/material.dart';

Widget buildFacultList(List<String> faculty) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: faculty.length,
    itemBuilder: (context, index) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.1),
          child: Text(
            faculty[index][0],
            style: const TextStyle(color: Colors.black),
          ),
        ),
        title: Text(
          faculty[index],
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        contentPadding: EdgeInsets.zero,
      );
    },
  );
}
