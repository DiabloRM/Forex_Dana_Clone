import 'package:flutter/material.dart';

/// Centralized icon management for consistent icon usage across the app
class AppIcons {
  // Private constructor to prevent instantiation
  AppIcons._();

  // Navigation Icons
  static const IconData markets = Icons.trending_up_rounded;
  static const IconData positions = Icons.account_balance_wallet_rounded;
  static const IconData square = Icons.dashboard_rounded;
  static const IconData profile = Icons.person_rounded;

  // Trading Icons
  static const IconData buy = Icons.trending_up_rounded;
  static const IconData sell = Icons.trending_down_rounded;
  static const IconData chart = Icons.show_chart_rounded;
  static const IconData candlestick = Icons.bar_chart_rounded;
  static const IconData volume = Icons.volume_up_rounded;
  static const IconData price = Icons.attach_money_rounded;

  // Market Icons
  static const IconData forex = Icons.currency_exchange_rounded;
  static const IconData crypto = Icons.currency_bitcoin_rounded;
  static const IconData metals = Icons.diamond_rounded;
  static const IconData stocks = Icons.business_center_rounded;
  static const IconData commodities = Icons.inventory_rounded;

  // Action Icons
  static const IconData search = Icons.search_rounded;
  static const IconData filter = Icons.filter_list_rounded;
  static const IconData sort = Icons.sort_rounded;
  static const IconData refresh = Icons.refresh_rounded;
  static const IconData favorite = Icons.favorite_rounded;
  static const IconData favoriteBorder = Icons.favorite_border_rounded;
  static const IconData star = Icons.star_rounded;
  static const IconData starBorder = Icons.star_border_rounded;

  // Communication Icons
  static const IconData chat = Icons.chat_bubble_rounded;
  static const IconData message = Icons.message_rounded;
  static const IconData notification = Icons.notifications_rounded;
  static const IconData notificationBorder = Icons.notifications_none_rounded;
  static const IconData support = Icons.support_agent_rounded;
  static const IconData help = Icons.help_rounded;

  // User Icons
  static const IconData user = Icons.person_rounded;
  static const IconData settings = Icons.settings_rounded;
  static const IconData logout = Icons.logout_rounded;
  static const IconData login = Icons.login_rounded;
  static const IconData register = Icons.person_add_rounded;

  // Financial Icons
  static const IconData deposit = Icons.add_circle_rounded;
  static const IconData withdraw = Icons.remove_circle_rounded;
  static const IconData transfer = Icons.swap_horiz_rounded;
  static const IconData balance = Icons.account_balance_rounded;
  static const IconData wallet = Icons.account_balance_wallet_rounded;
  static const IconData creditCard = Icons.credit_card_rounded;

  // Feature Icons
  static const IconData task = Icons.task_alt_rounded;
  static const IconData demo = Icons.play_circle_rounded;
  static const IconData referral = Icons.group_add_rounded;
  static const IconData mining = Icons.diamond_rounded;
  static const IconData coupon = Icons.local_offer_rounded;
  static const IconData gift = Icons.card_giftcard_rounded;

  // Status Icons
  static const IconData success = Icons.check_circle_rounded;
  static const IconData error = Icons.error_rounded;
  static const IconData warning = Icons.warning_rounded;
  static const IconData info = Icons.info_rounded;
  static const IconData loading = Icons.hourglass_empty_rounded;

  // Direction Icons
  static const IconData up = Icons.keyboard_arrow_up_rounded;
  static const IconData down = Icons.keyboard_arrow_down_rounded;
  static const IconData left = Icons.keyboard_arrow_left_rounded;
  static const IconData right = Icons.keyboard_arrow_right_rounded;
  static const IconData back = Icons.arrow_back_ios_rounded;
  static const IconData forward = Icons.arrow_forward_ios_rounded;

  // Chart Icons
  static const IconData zoomIn = Icons.zoom_in_rounded;
  static const IconData zoomOut = Icons.zoom_out_rounded;
  static const IconData fullscreen = Icons.fullscreen_rounded;
  static const IconData timeline = Icons.timeline_rounded;
  static const IconData analytics = Icons.analytics_rounded;

  // Social Icons
  static const IconData share = Icons.share_rounded;
  static const IconData like = Icons.thumb_up_rounded;
  static const IconData dislike = Icons.thumb_down_rounded;
  static const IconData comment = Icons.comment_rounded;
  static const IconData follow = Icons.person_add_rounded;

  // Utility Icons
  static const IconData close = Icons.close_rounded;
  static const IconData menu = Icons.menu_rounded;
  static const IconData more = Icons.more_vert_rounded;
  static const IconData edit = Icons.edit_rounded;
  static const IconData delete = Icons.delete_rounded;
  static const IconData copy = Icons.copy_rounded;
  static const IconData download = Icons.download_rounded;
  static const IconData upload = Icons.upload_rounded;

  // Time Icons
  static const IconData time = Icons.access_time_rounded;
  static const IconData calendar = Icons.calendar_today_rounded;
  static const IconData clock = Icons.schedule_rounded;
  static const IconData history = Icons.history_rounded;

  // Security Icons
  static const IconData security = Icons.security_rounded;
  static const IconData lock = Icons.lock_rounded;
  static const IconData unlock = Icons.lock_open_rounded;
  static const IconData key = Icons.vpn_key_rounded;
  static const IconData fingerprint = Icons.fingerprint_rounded;

  // Network Icons
  static const IconData wifi = Icons.wifi_rounded;
  static const IconData signal = Icons.signal_cellular_alt_rounded;
  static const IconData offline = Icons.cloud_off_rounded;
  static const IconData online = Icons.cloud_done_rounded;

  // Custom icon sizes for consistent sizing
  static const double sizeSmall = 16.0;
  static const double sizeMedium = 20.0;
  static const double sizeLarge = 24.0;
  static const double sizeXLarge = 32.0;
  static const double sizeXXLarge = 48.0;

  // Icon color schemes
  static const Color colorPrimary = Colors.blue;
  static const Color colorSecondary = Colors.grey;
  static const Color colorSuccess = Colors.green;
  static const Color colorError = Colors.red;
  static const Color colorWarning = Colors.orange;
  static const Color colorInfo = Colors.blue;

  /// Helper method to get icon with consistent styling
  static Widget getIcon(
    IconData icon, {
    double? size,
    Color? color,
    String? semanticLabel,
  }) {
    return Icon(
      icon,
      size: size ?? sizeMedium,
      color: color,
      semanticLabel: semanticLabel,
    );
  }

  /// Helper method to get icon button with consistent styling
  static Widget getIconButton(
    IconData icon, {
    VoidCallback? onPressed,
    double? size,
    Color? color,
    String? tooltip,
    EdgeInsetsGeometry? padding,
  }) {
    return IconButton(
      icon: getIcon(icon, size: size, color: color),
      onPressed: onPressed,
      tooltip: tooltip,
      padding: padding,
    );
  }

  /// Helper method to get category icon based on market type
  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'forex':
        return forex;
      case 'crypto':
        return crypto;
      case 'metals':
        return metals;
      case 'stocks':
        return stocks;
      case 'commodities':
        return commodities;
      default:
        return chart;
    }
  }

  /// Helper method to get status icon based on market status
  static IconData getStatusIcon(bool isOpen) {
    return isOpen ? success : error;
  }

  /// Helper method to get trend icon based on price direction
  static IconData getTrendIcon(bool isUp) {
    return isUp ? up : down;
  }
}
