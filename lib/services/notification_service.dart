import 'dart:convert';
import 'package:flutter/services.dart'; // for rootBundle
import 'package:http/http.dart' as http;

import 'package:furniscapemobileapp/models/notification_model.dart';

class NotificationService {
  final String externalUrl;

  NotificationService({required this.externalUrl});

  Future<List<NotificationItem>> fetchExternalNotifications() async {
    final response = await http.get(Uri.parse(externalUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => NotificationItem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch notifications');
    }
  }

  Future<List<NotificationItem>> loadLocalNotifications() async {
    final jsonString = await rootBundle.loadString('assets/notifications.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => NotificationItem.fromJson(e)).toList();
  }

  Future<List<NotificationItem>> getNotifications({bool forceLocal = false}) async {
    if (!forceLocal) {
      try {
        return await fetchExternalNotifications();
      } catch (e) {
        // fallback to local
        return await loadLocalNotifications();
      }
    } else {
      return await loadLocalNotifications();
    }
  }
}
