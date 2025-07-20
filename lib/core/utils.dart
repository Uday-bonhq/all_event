import 'package:all_event/core/app_colors.dart';
import 'package:all_event/core/resources/asset_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) {
    return text;
  }
  return '${text[0].toUpperCase()}${text.substring(1)}';
}



shareContent(shareUrl){
  HapticFeedback.mediumImpact();
  return SharePlus.instance.share(
      ShareParams(text: shareUrl)
  );
}


Widget customNetworkImage({
  required String? imageUrl,
  double borderRadius = 8.0,
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
  String fallbackAsset = 'assets/images/placeholder.png',
}) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return _fallbackImage(borderRadius, fallbackAsset, fit, width, height);
  }

  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => _fallbackImage(borderRadius, fallbackAsset, fit, width, height),
      errorWidget: (context, url, error) => _fallbackImage(borderRadius, fallbackAsset, fit, width, height),
    ),
  );
}

Widget _fallbackImage(double borderRadius, String asset, BoxFit fit, double? width, double? height) {
  return Container(
    padding: const EdgeInsets.all(8),
    height: height,width: width,
    decoration: BoxDecoration(
      color: primaryColor.withOpacity(0.7),
      borderRadius: BorderRadius.circular(borderRadius),
    ),

    child: SvgPicture.asset(AssetIcon.appLogo, height: height,width: width,),
  );
}
