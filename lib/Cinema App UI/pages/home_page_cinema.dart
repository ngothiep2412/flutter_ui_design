import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ui_design/Cinema%20App%20UI/constants/constants.dart';
import 'package:flutter_ui_design/Cinema%20App%20UI/models/category_model.dart';
import 'package:flutter_ui_design/Cinema%20App%20UI/models/movie_model.dart';
import 'package:flutter_ui_design/Cinema%20App%20UI/pages/detail_page.dart';

class HomePageCinema extends StatefulWidget {
  const HomePageCinema({super.key});

  @override
  State<HomePageCinema> createState() => _HomePageCinemaState();
}

class _HomePageCinemaState extends State<HomePageCinema> {
  late PageController controller;
  double pageOffSet = 1;
  int currentIndex = 1;

  @override
  void initState() {
    controller = PageController(initialPage: 1)
      ..addListener(() {
        setState(() {
          pageOffSet = controller.page!;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: const _AppBar(),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 35,
            ),
            const _Search(),
            const SizedBox(
              height: 30,
            ),
            const Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Category',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'See All',
                            style: TextStyle(
                              color: buttonColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: buttonColor,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 17,
            ),
            const CategoryItems(),
            const SizedBox(
              height: 40,
            ),
            Container(
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Showing this month",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PageView.builder(
                          controller: controller,
                          onPageChanged: (index) {
                            setState(() {
                              currentIndex = index % movies.length;
                            });
                          },
                          itemBuilder: (context, index) {
                            double scale = max(
                              0.6,
                              (1 - (pageOffSet - index).abs() + 0.6),
                            );
                            double angle = (controller.position.haveDimensions
                                    ? index.toDouble() - (controller.page ?? 0)
                                    : index.toDouble() - 1) *
                                5;
                            angle = angle.clamp(-5, 5);
                            final movie = movies[index % movies.length];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        MovieDetailPage(movie: movie),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 100 - (scale / 1.6 * 100),
                                ),
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Transform.rotate(
                                      angle: angle * pi / 90,
                                      child: Hero(
                                        tag: movie.poster,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: Image.network(
                                            movie.poster,
                                            height: 300,
                                            width: 205,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        // Positioned(
                        //   top: 300,
                        //   child: Row(
                        //     children: List.generate(
                        //       movies.length,
                        //       (index) => AnimatedContainer(
                        //         duration: const Duration(milliseconds: 300),
                        //         margin: const EdgeInsets.only(right: 15),
                        //         width: currentIndex == index ? 30 : 10,
                        //         height: 10,
                        //         decoration: BoxDecoration(
                        //           color: currentIndex == index
                        //               ? buttonColor
                        //               : Colors.white24,
                        //           borderRadius: BorderRadius.circular(15),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                movies.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: 15),
                  width: currentIndex == index ? 30 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: currentIndex == index ? buttonColor : Colors.white24,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItems extends StatelessWidget {
  const CategoryItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        categories.length,
        (index) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white10.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(
                categories[index].emoji,
                fit: BoxFit.cover,
                width: 30,
                height: 30,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              categories[index].name,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Search extends StatelessWidget {
  const _Search();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 17),
          filled: true,
          fillColor: Colors.white.withOpacity(.05),
          hintText: "Search",
          hintStyle: const TextStyle(
            color: Colors.white54,
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 32,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(27),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appBackgroundColor,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome Thiep',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                          color: Colors.white54,
                        ),
                      ),
                      TextSpan(
                        text: '👋',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Let's relax and watch a move ",
                  style: TextStyle(
                    height: 0.6,
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            Container(
              width: 40,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://t3.ftcdn.net/jpg/06/07/84/82/240_F_607848231_w5iFN4tMmtI2woJjMh7Q8mGvgARnzHgQ.jpg'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
