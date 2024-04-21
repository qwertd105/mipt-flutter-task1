import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../core/app_state.dart';
import '../data/models/article_model.dart';
import '../domain/utils/news.dart';

import 'home.dart' show BlogTile;

class CategoryNews extends StatefulWidget {
  final String category;

  const CategoryNews({super.key, required this.category});

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  late final List<ArticleModel> articles;
  final favourites = Hive.box('favourites');
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getCatNews();
  }

  getCatNews() async {
    if (widget.category == 'favourite') {
      News newsTable = News();
      await newsTable.getNews();
      articles = newsTable.news
          .where((element) => favourites.get(element.url) != null)
          .toList();
    } else {
      CatNews newsTable = CatNews();
      await newsTable.getCatNews(widget.category);
      articles = newsTable.news;
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "NewsPaper",
              style: TextStyle(color: Colors.orange, fontSize: 30),
            ),
            Consumer<AppState>(
              builder: (context, appState, child) {
                return IconButton(
                    onPressed: () {
                      appState.toggleTheme();
                    },
                    icon: Icon(appState.isDark
                        ? Icons.sunny
                        : Icons.nightlight_round));
              },
            )
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    child: ListView.builder(
                        itemCount: articles.length,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) => BlogTile(
                              imgUrl: articles[index].urlToImage,
                              title: articles[index].title,
                              description: articles[index].description,
                              url: articles[index].url,
                            )),
                  ),
                ],
              ),
            ));
}
