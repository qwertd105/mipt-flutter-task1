import 'package:hive/hive.dart';
import 'package:tsk1/helper/data.dart';

import 'package:tsk1/models/category_model.dart';
import 'package:tsk1/views/article_view.dart';
import 'package:tsk1/views/category_news.dart';
import '../helper/app_state.dart';
import '../helper/news.dart';
import '../models/article_model.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final List<CategoryModel> categories;
  late final List<ArticleModel> articles;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async {
    News newsTable = News();
    await newsTable.getNews();

    articles = newsTable.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build (BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("NewsPaper",
            style: TextStyle(color: Colors.orange, fontSize: 30),),
          Consumer<AppState>(
            builder: (context, appState, child) {
              return IconButton(onPressed: () {
                appState.toggleTheme();
              }, icon: Icon(appState.isDark ? Icons.sunny : Icons.nightlight_round));
            },
          )
        ],
      ),
      centerTitle: true,
      elevation: 0.0,
    ),
    body: _loading
        ?
    const Center(child: CircularProgressIndicator(),)
        :
    SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: <Widget>[

          /// Categories
          SizedBox(
            height: 80,
            child: ListView.builder(
                itemCount: categories.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CategoryTile(
                    imageURL: categories[index].imgUrl,
                    categoryTitle: categories[index].categoryName,
                  );
                }
            ),
          ),

          /// Blogs
          Container(
            padding: const EdgeInsets.only(top: 24),
            child: ListView.builder(
                itemCount: articles.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return BlogTile(
                    imgUrl: articles[index].urlToImage,
                    title: articles[index].title,
                    description: articles[index].description,
                    url: articles[index].url,
                  );
                }
            ),
          ),
        ],
      ),
    ),
  );
}

class CategoryTile extends StatelessWidget {
  final String? imageURL, categoryTitle;

  const CategoryTile({super.key, this.imageURL, this.categoryTitle});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => CategoryNews(category: categoryTitle!.toLowerCase())
      )
      );
    },
    child: Container(
      margin: const EdgeInsets.only(right: 16),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(imageURL!, width: 128, height: 80, fit: BoxFit.cover,),
          ),
          Container(
            alignment: Alignment.center,
            width: 128, height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black38,
            ),
            child: Text(categoryTitle!,
              style:
              const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          )
        ],
      ),
    ),
  );
}

class BlogTile extends StatefulWidget {
  final String? imgUrl, title, description, url;

  const BlogTile({super.key, required this.imgUrl, required this.title, required this.description, required this.url});

  @override
  State<BlogTile> createState() => _BlogTileState();
}

class _BlogTileState extends State<BlogTile> {
  bool isLiked = false;
  final favourites = Hive.box('favourites');

  @override
  void initState(){
    super.initState();
    isLiked = favourites.get(widget.url) != null;
  }

  toggleLike(){
    if (!isLiked) {
      favourites.put(widget.url, true);
    } else {
      favourites.delete(widget.url);
    }

    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ArticleView(
                blogUrl: widget.url!,
            )
          )
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
                child: Image.network(widget.imgUrl!),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.title!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                LikeButton(isLiked: isLiked, onTap: toggleLike),
              ],
            ),
            const SizedBox(height: 8,),
            Text(
              widget.description!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400
              )
            ),
          ],
        ),
      ),
    );
  }
}

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final Function()? onTap;
  const LikeButton({super.key, required this.isLiked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.grey,
      ),
    );
  }
}