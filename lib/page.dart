import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class PageCard extends StatelessWidget {
  String iconUrl;
  String title;
  String description;
  String url;
  PageCard(
      {super.key,
      required this.iconUrl,
      required this.title,
      required this.url,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 180,
        width: 310,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border: Border.all(width: 1, color: Colors.grey.withOpacity(0.3))),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    child: CachedNetworkImage(
                      imageUrl: iconUrl,
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
                  ),
                ),
                Expanded(
                    child: ListTile(
                  title: Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  subtitle: Text(
                    description,
                    style: const TextStyle(fontSize: 15),
                  ),
                ))
              ],
            )),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.7),
              ),
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                child: const Center(child: Text("官方网址")),
                onPressed: () {
                  launchUrl(Uri.parse(url));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
