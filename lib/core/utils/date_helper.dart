/// Date helper utilities for parsing different date formats
class DateHelper {
  /// Parse date from API response that can be in multiple formats
  /// Supports both RFC format (Mon, 23 Jun 2025 23:40:39 GMT) and ISO format (2025-06-30T22:14:22.087279Z)
  static DateTime parseApiDate(String dateString) {
    try {
      // First try ISO format (most common)
      return DateTime.parse(dateString);
    } catch (e) {
      try {
        // Try RFC format: Mon, 23 Jun 2025 23:40:39 GMT
        return DateTime.parse(dateString.replaceAll(' GMT', 'Z').replaceAll(' ', 'T'));
      } catch (e2) {
        try {
          // Try parsing as RFC 2822 format
          return _parseRfcDate(dateString);
        } catch (e3) {
          // If all parsing fails, return current time and log error
          print('Failed to parse date: $dateString. Error: $e3');
          return DateTime.now();
        }
      }
    }
  }

  /// Parse RFC 2822 date format: Mon, 23 Jun 2025 23:40:39 GMT
  static DateTime _parseRfcDate(String rfcDate) {
    // Map month names to numbers
    const monthMap = {
      'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04',
      'May': '05', 'Jun': '06', 'Jul': '07', 'Aug': '08',
      'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'
    };

    // Parse: Mon, 23 Jun 2025 23:40:39 GMT
    final parts = rfcDate.split(' ');
    if (parts.length >= 5) {
      final day = parts[1].padLeft(2, '0');
      final month = monthMap[parts[2]] ?? '01';
      final year = parts[3];
      final time = parts[4];

      // Create ISO format: 2025-06-23T23:40:39Z
      final isoDate = '$year-$month-${day}T${time}Z';
      return DateTime.parse(isoDate);
    }

    throw FormatException('Invalid RFC date format: $rfcDate');
  }

  /// Format DateTime to display string
  static String formatDisplayDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Format DateTime to display string with time
  static String formatDisplayDateTime(DateTime date) {
    return '${formatDisplayDate(date)} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
