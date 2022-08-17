import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int activeIndex;
  final Function setPage;

  const NavBar({required this.activeIndex, required this.setPage, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
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
                      width: 100,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        onPressed: () {
                          setPage(0);
                        },
                        minWidth: 40,
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
                      width: 100,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
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
                                      : Color.fromRGBO(0, 0, 0, 0.3)),
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
