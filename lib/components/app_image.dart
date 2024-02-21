import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    Key? key,
    this.img = '',
    this.width = 0,
    this.height = 0,
    this.borderRadius = 0,
    this.boxfit,
  }) : super(key: key);
  final String img;
  final double width;
  final double height;
  final double borderRadius;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    if (img == '') {
      return Container();
    }

    return CachedNetworkImage(
      imageUrl: img,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          image: DecorationImage(
            image: imageProvider,
            fit: boxfit ?? BoxFit.fill,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: const Center(
          child: SpinKitThreeBounce(
            color: Colors.white,
            size: 20.0,
          ),
        ),
      ),
      errorWidget: (context, url, error) => SizedBox(
        width: width,
        height: height,
        child: const Icon(
          Icons.broken_image_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
