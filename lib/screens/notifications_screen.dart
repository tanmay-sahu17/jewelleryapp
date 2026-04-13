import 'package:flutter/material.dart';
import 'package:shri_jewellers/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../models/notification_model.dart';
import '../providers/shop_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/premium_background.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () {
              final ShopProvider provider = context.read<ShopProvider>();
              final int unreadCount = provider.unreadNotificationCount;
              provider.markAllNotificationsRead();
              if (unreadCount > 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.notificationsMarkedRead(unreadCount))),
                );
              }
            },
            icon: const Icon(Icons.done_all_rounded, size: 16),
            label: Text(l10n.markAll),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: PremiumBackground(
        child: Consumer<ShopProvider>(
          builder: (BuildContext context, ShopProvider provider, Widget? child) {
            final List<ShopNotification> notifications = provider.notifications;

            if (notifications.isEmpty) {
              return EmptyState(
                title: l10n.notificationsEmptyTitle,
                subtitle: l10n.notificationsEmptySubtitle,
                icon: Icons.notifications_none_rounded,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.only(top: 12, bottom: 20),
              itemBuilder: (BuildContext context, int index) {
                final ShopNotification item = notifications[index];
                return _NotificationCard(
                  item: item,
                  onTap: () => provider.markNotificationRead(item.id),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: notifications.length,
            );
          },
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item, required this.onTap});

  final ShopNotification item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: AppColors.charcoal.withValues(alpha: 0.97),
            border: Border.all(
              color: item.isRead
                  ? AppColors.border
                  : AppColors.gold.withValues(alpha: 0.48),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold.withValues(alpha: 0.16),
                ),
                child: Icon(_iconByKind(item.kind), color: AppColors.softGold, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            item.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Text(
                          _timeLabel(item.createdAt, context),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: AppColors.mutedText),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.message,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.mutedText),
                    ),
                  ],
                ),
              ),
              if (!item.isRead)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 6),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.softGold,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _timeLabel(DateTime createdAt, BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Duration diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) {
      return l10n.justNow;
    }
    if (diff.inMinutes < 60) {
      return l10n.minutesAgo(diff.inMinutes);
    }
    if (diff.inHours < 24) {
      return l10n.hoursAgo(diff.inHours);
    }
    if (diff.inDays == 1) {
      return l10n.yesterday;
    }
    return l10n.daysAgo(diff.inDays);
  }

  IconData _iconByKind(ShopNotificationKind kind) {
    switch (kind) {
      case ShopNotificationKind.rate:
        return Icons.currency_rupee_rounded;
      case ShopNotificationKind.offer:
        return Icons.local_offer_rounded;
      case ShopNotificationKind.status:
        return Icons.storefront_outlined;
      case ShopNotificationKind.general:
        return Icons.notifications_active_outlined;
    }
  }
}
