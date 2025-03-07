import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/constant/color_constant.dart';
import 'package:task/project_specific/text_theme.dart';


class TvshowScreen extends StatefulWidget {
  const TvshowScreen({super.key});

  @override
  State<TvshowScreen> createState() => _TvshowScreenState();
}

class _TvshowScreenState extends State<TvshowScreen> {
  final List<String> imageList = [
    'https://webartdevelopers.com/blog/wp-content/uploads/2018/12/fancy-slider.png',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZxBIwemN0Qqilz4etnzD5hpbVqbRBsJHWNA&s',
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREDRvMfKQQycMI4xmR-1SyHh969BPF7zwSwA&s",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          CarouselSlider(
            options: CarouselOptions(
              height: Get.height * 0.2,
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              autoPlayInterval: const Duration(seconds: 3),
              viewportFraction: 0.8,
            ),
            items: imageList.map((imageUrl) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: Get.width,
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "latest".tr,
                style: AppTextTheme.semibold.copyWith(
                  fontSize: 24,
                  color: ColorConstant.whiteColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 300,
            child: Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: imageList.length,
                itemBuilder: (BuildContext context, int index)
                {
                  return Container(
                      width: 200,
                      height: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(color: ColorConstant.whiteColor,blurRadius: 1,)
                          ],
                          image:DecorationImage(image: NetworkImage(imageList[index]),fit: BoxFit.cover))


                  );
                }, separatorBuilder: (BuildContext context, int index) => SizedBox(width: 10),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "top_10_videos".tr,
                style: AppTextTheme.semibold.copyWith(
                  fontSize: 24,
                  color: ColorConstant.whiteColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 300,
            child: Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: imageList.length,
                itemBuilder: (BuildContext context, int index)
                {
                  return Container(
                      width: 200,
                      height: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(color: ColorConstant.whiteColor,blurRadius: 1,)
                          ],
                          image:DecorationImage(image: NetworkImage(imageList[index]),fit: BoxFit.cover))


                  );
                }, separatorBuilder: (BuildContext context, int index) => SizedBox(width: 10),
              ),
            ),
          ),
          SizedBox(height: 30)
        ],
      ),
    );
  }
}
