import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:furniscapemobileapp/providers/notification_provider.dart';


class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          if (provider.notifications.isEmpty) {
            return const Center(child: Text('No notifications found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notification = provider.notifications[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: notification.imageUrl != null
                      ? Image.network(notification.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                      : null,
                  title: Text(notification.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(notification.body),
                  trailing: Text(
                    '${notification.date.day}/${notification.date.month}/${notification.date.year}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
