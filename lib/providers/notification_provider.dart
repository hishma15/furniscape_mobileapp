import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:furniscapemobileapp/models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationItem> _notifications = [];
  bool _isLoading = false;
  String? _error;

  List<NotificationItem> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final url = Uri.parse('https://raw.githubusercontent.com/hishma15/furniscape-notifications/refs/heads/main/notification.json');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _notifications = data.map((json) => NotificationItem.fromJson(json)).toList();
      } else {
        _error = 'Failed to load notifications. Status: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Failed to load notifications: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
