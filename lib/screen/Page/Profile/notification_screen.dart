import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/constant/color_constant.dart';
import 'package:task/project_specific/text_theme.dart';


class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {"title": "New Movie Released!", "message": "Check out the latest blockbuster now.", "isRead": false, "time": "5 min ago"},
    {"title": "Subscription Expiring Soon", "message": "Renew your subscription to continue streaming.", "isRead": false, "time": "1 hour ago"},
    {"title": "Live Event!", "message": "Join the live Q&A with your favorite actors.", "isRead": true, "time": "Yesterday"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("notifications".tr, style: AppTextTheme.medium.copyWith(color: ColorConstant.whiteColor)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all, color: Colors.red),
            onPressed: _clearAllNotifications,
            tooltip: "clear_all".tr,
          ),
        ],
      ),
      body: _notifications.isEmpty ? _buildEmptyState() : _buildNotificationList(),
    );
  }

  /// **Empty Notification State UI**
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off, size: 80, color: Colors.white30),
          const SizedBox(height: 10),
          Text(
            "no_notifications".tr,
            style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            "all_caught_up".tr,
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// **Notification List with Swipe Actions**
  Widget _buildNotificationList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];

        return Dismissible(
          key: Key(notification["title"]),
          background: _swipeActionBackground(Colors.red, Icons.delete, "delete".tr),
          secondaryBackground: _swipeActionBackground(Colors.green, Icons.done, "mark_read".tr),
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              _deleteNotification(index);
            } else {
              _markAsRead(index);
            }

            // Ensure UI updates **after** the widget is removed
            Future.microtask(() => setState(() {}));
          },
          child: _buildNotificationCard(notification, index),
        );
      },
    );
  }

  /// **Notification Card UI**
  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    return Card(
      color: notification["isRead"] ? Colors.grey[900] : Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: notification["isRead"] ? Colors.grey : ColorConstant.primary,
          child: Icon(Icons.notifications, color: Colors.white),
        ),
        title: Text(
          notification["title"],
          style: AppTextTheme.bold.copyWith(color: Colors.white, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification["message"], style: const TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 5),
            Text(notification["time"], style: const TextStyle(color: Colors.white38, fontSize: 12)),
          ],
        ),
        trailing: IconButton(
          icon: Icon(notification["isRead"] ? Icons.visibility_off : Icons.visibility, color: Colors.white38),
          onPressed: () => _toggleReadStatus(index),
        ),
      ),
    );
  }

  /// **Swipe Action Background**
  Widget _swipeActionBackground(Color color, IconData icon, String label) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  /// **Toggle Read Status**
  void _toggleReadStatus(int index) {
    setState(() {
      _notifications[index]["isRead"] = !_notifications[index]["isRead"];
    });
  }

  /// **Mark Notification as Read**
  void _markAsRead(int index) {
    setState(() {
      _notifications[index]["isRead"] = true;
    });
  }

  /// **Delete Notification with Undo Option**
  void _deleteNotification(int index) {
    final deletedNotification = _notifications[index];

    setState(() {
      _notifications.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("notification_deleted".tr),
        action: SnackBarAction(
          label: "undo".tr,
          textColor: Colors.yellow,
          onPressed: () {
            setState(() {
              _notifications.insert(index, deletedNotification);
            });
          },
        ),
      ),
    );
  }

  /// **Clear All Notifications with Confirmation**
  void _clearAllNotifications() {
    if (_notifications.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title:Text("clear_notifications".tr, style: TextStyle(color: Colors.white)),
          content: Text("confirm_clear_notifications".tr, style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("cancel".tr, style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() {
                  _notifications.clear();
                });
                Navigator.pop(context);
              },
              child:Text("clear_all".tr),
            ),
          ],
        );
      },
    );
  }
}
