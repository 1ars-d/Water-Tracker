import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int activeIndex;
  final Function setPage;

  const NavBar({required this.activeIndex, required this.setPage, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
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
      child: SizedBox(
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
                      child: MaterialButton(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
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
                                      : const Color.fromRGBO(0, 0, 0, 0.3)),
                            )
                          ],
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
                      child: MaterialButton(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        enableFeedback: false,
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
                              "Statistics",
                              style: TextStyle(
                                  color: activeIndex == 1
                                      ? Colors.black87
                                      : const Color.fromRGBO(0, 0, 0, 0.3)),
                            )
                          ],
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
    );
  }
}
