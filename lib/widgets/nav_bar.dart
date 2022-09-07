import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int activeIndex;
  final Function setPage;

  const NavBar({required this.activeIndex, required this.setPage, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      /* shape: const AutomaticNotchedShape(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(0),
          ),
        ),
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      notchMargin: 7, */
      child: Container(
        height: 71,
        decoration: const BoxDecoration(
            border: BorderDirectional(
                top: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.1)))),
        child: Column(
          children: [
            SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 110,
                            child: Tooltip(
                              message: "Home",
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    splashFactory: NoSplash.splashFactory,
                                    primary: Colors.grey),
                                onPressed: () {
                                  setPage(0);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.apps,
                                      size: 30,
                                      color: activeIndex == 0
                                          ? Colors.black87
                                          : const Color.fromRGBO(0, 0, 0, 0.3),
                                    ),
                                    Text(
                                      "Home",
                                      style: TextStyle(
                                          color: activeIndex == 0
                                              ? Colors.black87
                                              : const Color.fromRGBO(
                                                  0, 0, 0, 0.3)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 110,
                            child: Tooltip(
                              message: "History",
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    splashFactory: NoSplash.splashFactory,
                                    primary: Colors.grey),
                                onPressed: () {
                                  setPage(1);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.bar_chart,
                                      size: 30,
                                      color: activeIndex == 1
                                          ? Colors.black87
                                          : const Color.fromRGBO(0, 0, 0, 0.3),
                                    ),
                                    Text(
                                      "History",
                                      style: TextStyle(
                                          color: activeIndex == 1
                                              ? Colors.black87
                                              : const Color.fromRGBO(
                                                  0, 0, 0, 0.3)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
