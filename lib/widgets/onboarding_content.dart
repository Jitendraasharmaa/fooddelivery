class OnBoardingContent {
  String? image;
  String? title;
  String? description;

  OnBoardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnBoardingContent> contents = [
  OnBoardingContent(
    image: "assets/images/screen1.png",
    title: "Title",
    description: "Ipsum has been the industry's\n standard dummy text ever since ",
  ),
  OnBoardingContent(
    image: "assets/images/screen2.png",
    title: "Title",
    description: "Ipsum has been the industry's standard dummy text ever since ",
  ),
  OnBoardingContent(
    image: "assets/images/screen3.png",
    title: "Title",
    description: "Ipsum has been the industry's standard dummy text ever since ",
  ),
];
