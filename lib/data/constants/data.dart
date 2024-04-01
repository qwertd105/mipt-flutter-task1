import '../models/category_model.dart';

List<CategoryModel> getCategories() {

  List<CategoryModel> categories = List<CategoryModel>.empty(growable: true);
  CategoryModel categoryModel = CategoryModel();

  categoryModel = CategoryModel();
  categoryModel.categoryName = "Favourite";
  categoryModel.imgUrl = 'assets/news_categories/AmercianHeartMonth-1 .jpg';
  categories.add(categoryModel);

  categoryModel = CategoryModel();
  categoryModel.categoryName = "Health";
  categoryModel.imgUrl = 'assets/news_categories/svitlana-hclUIrSWwFE-unsplash.jpg';
  categories.add(categoryModel);

  categoryModel = CategoryModel();
  categoryModel.categoryName = "Politics";
  categoryModel.imgUrl = 'assets/news_categories/hansjorg-keller-p7av1ZhKGBQ-unsplash.jpg';
  categories.add(categoryModel);

  categoryModel = CategoryModel();
  categoryModel.categoryName = "Sport";
  categoryModel.imgUrl = 'assets/news_categories/connor-coyne-OgqWLzWRSaI-unsplash.jpg';
  categories.add(categoryModel);

  categoryModel = CategoryModel();
  categoryModel.categoryName = "Technology";
  categoryModel.imgUrl = 'assets/news_categories/alexandre-debieve-FO7JIlwjOtU-unsplash.jpg';
  categories.add(categoryModel);

  categoryModel = CategoryModel();
  categoryModel.categoryName = "Business";
  categoryModel.imgUrl = 'assets/news_categories/alexander-grey-8lnbXtxFGZw-unsplash.jpg';
  categories.add(categoryModel);

  return categories;
}