import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = "/about";
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Colors.transparent,

            // Status bar brightness (optional)
            statusBarIconBrightness:
                Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          title: const Text("More"),
          surfaceTintColor: Colors.white,
          shadowColor: const Color.fromRGBO(0, 0, 0, 0.2),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context, true),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await launchUrl(
                    Uri.parse("mailto:minimal.water.tracker@gmail.com"));
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                overlayColor: MaterialStateProperty.all(Colors.black12),
                padding: MaterialStateProperty.all(const EdgeInsets.only(
                    left: 15, top: 10, bottom: 10, right: 15)),
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xffefefef)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(
                    Icons.mail_outline,
                    color: Color(0xff767676),
                  ),
                  Text(
                    "Contact",
                    style: TextStyle(color: Color(0xff767676)),
                  ),
                  SizedBox(),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await launchUrl(Uri.parse(
                    "https://sites.google.com/view/minimal-water-tracker-privacy/startseite"));
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                overlayColor: MaterialStateProperty.all(Colors.black12),
                padding: MaterialStateProperty.all(const EdgeInsets.only(
                    left: 15, top: 10, bottom: 10, right: 15)),
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xffefefef)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(
                    Icons.article_outlined,
                    color: Color(0xff767676),
                  ),
                  Text(
                    "Privacy Policy",
                    style: TextStyle(color: Color(0xff767676)),
                  ),
                  SizedBox(),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Attribution",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(0, 0, 0, 0.7),
                fontSize: 20),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 30,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Row(
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            primary: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0))),
                        onPressed: () async {
                          const url =
                              "https://www.freepik.com/free-vector/collection-beverage-vectors_2800691.htm#query=soda%20bottle&position=21&from_view=keyword";
                          await launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalApplication);
                        },
                        child: const Text("Collection of beverage vectors")),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "by rawpixel.com on Freepik",
                      style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
