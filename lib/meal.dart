class Ingredient {
  final String ingredient;
  final String measure;

  Ingredient({
    required this.ingredient,
    required this.measure,
  });
}


class Meal {
  final String idMeal;
  final String strMeal;
  final String? strDrinkAlternate;
  final String idCategory;
  final String strArea;
  final String strInstructions;
  final String strMealThumb;
  final String strTags;
  final String strYoutube;
  final List<Ingredient> ingredients;
  final String? strSource;
  final String? strImageSource;
  final String? strCreativeCommonsConfirmed;
  final String? dateModified;
  final String price;

  Meal({
    required this.idMeal,
    required this.strMeal,
    required this.strDrinkAlternate,
    required this.idCategory,
    required this.strArea,
    required this.strInstructions,
    required this.strMealThumb,
    required this.strTags,
    required this.strYoutube,
    required this.ingredients,
    required this.strSource,
    required this.strImageSource,
    required this.strCreativeCommonsConfirmed,
    required this.dateModified,
    required this.price,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<Ingredient> ingredientList = List<Ingredient>.generate(
      20,
      (index) {
        final ingredientKey = 'strIngredient${index + 1}';
        final measureKey = 'strMeasure${index + 1}';
        return Ingredient(
          ingredient: json[ingredientKey] as String,
          measure: json[measureKey] as String,
        );
      },
    );

    return Meal(
      idMeal: json['idMeal'] as String,
      strMeal: json['strMeal'] as String,
      strDrinkAlternate: json['strDrinkAlternate'] as String?,
      idCategory: json['idCategory'] as String,
      strArea: json['strArea'] as String,
      strInstructions: json['strInstructions'] as String,
      strMealThumb: json['strMealThumb'] as String,
      strTags: json['strTags'] as String,
      strYoutube: json['strYoutube'] as String,
      ingredients: ingredientList,
      strSource: json['strSource'] as String?,
      strImageSource: json['strImageSource'] as String?,
      strCreativeCommonsConfirmed: json['strCreativeCommonsConfirmed'] as String?,
      dateModified: json['dateModified'] as String?,
      price: json['price'] as String,
    );
  }
}