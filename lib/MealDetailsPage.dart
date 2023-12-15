import 'package:flutter/material.dart';

class MealDetailsPage extends StatelessWidget {
  final Map<String, dynamic> mealDetails;

  MealDetailsPage({required this.mealDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meal: ${mealDetails["strMeal"]}'),
            SizedBox(height: 8.0),
            Text('Category: ${mealDetails["idCategory"]}'),
            Text('Area: ${mealDetails["strArea"]}'),
            Text('Price: ${mealDetails["price"]}'),
            // Add other meal details here
          ],
        ),
      ),
    );
  }
}
