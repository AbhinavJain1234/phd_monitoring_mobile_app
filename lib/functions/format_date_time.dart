String formatDateTimeDuration(String dateTimeString) {
  final DateTime dateTime = DateTime.parse(dateTimeString);
  final Duration difference = DateTime.now().difference(dateTime);

  if (difference.inDays > 0) {
    return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
  } else {
    return 'Just now';
  }
}

String formatDateTime(String dateTimeString) {
  final DateTime dateTime = DateTime.parse(dateTimeString);
  final String formattedDate =
      '${_getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}';

  return formattedDate;
}

String _getMonthName(int month) {
  const List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return monthNames[month - 1];
}
