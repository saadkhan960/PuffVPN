import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CacheFlag extends StatelessWidget {
  const CacheFlag({
    super.key,
    required this.countryFlag,
    this.height = 30,
    this.width = 50,
  });

  final String countryFlag;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "https://flagsapi.com/$countryFlag/flat/64.png",
      placeholder: (context, url) => Skeletonizer(
        effect: const ShimmerEffect(
          baseColor: Color.fromARGB(255, 138, 140, 145),
        ),
        justifyMultiLineText: true,
        enableSwitchAnimation: true,
        ignoreContainers: true,
        enabled: true,
        child: SizedBox(
          width: width,
          height: height,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) => SizedBox(
        width: width,
        height: height,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/no-image.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
