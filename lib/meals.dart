import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'MealDetailsPage.dart';

class MealsPage extends StatefulWidget {
  @override
  _MealsPageState createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  List<dynamic> meals = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.168.56.1:3000/meals'));
    if (response.statusCode == 200) {
      setState(() {
        meals = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void viewDetails(int index) {
  Map<String, dynamic> mealDetails = meals[index];
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MealDetailsPage(mealDetails: mealDetails),
    ),
  );
}


  void deleteMeal(int index) async {
    try {
      final mealId = meals[index]["idMeal"];
      final response =
          await http.delete(Uri.parse('http://192.168.56.1:3000/meals/$mealId'));

      if (response.statusCode == 200) {
        print('Meal deleted successfully');
        fetchData(); // Refresh the meal list after deletion
      } else {
        print('Failed to delete meal. Status code: ${response.statusCode}');
        // Optionally, show an error message to the user
      }
    } catch (e) {
      print('Error: $e');
      // Optionally, show an error message to the user
    }
  }

  void addMeal() {
    // Implement logic to add a new meal
    print('Add New Meal');
    // You can navigate to an add page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 194, 33),
      appBar: AppBar(
        title: Text('Meals'),
      ),
      body: ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(meals[index]["strMeal"]),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category: ${meals[index]["idCategory"]}'),
                  Text('Area: ${meals[index]["strArea"]}'),
                  Text('Price: ${meals[index]["price"]}'),
                ],
              ),
              leading: Image.network(meals[index]["strMealThumb"]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.details),
                    onPressed: () {
                      viewDetails(index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      //editMeal(index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteMeal(index);
                    },
                  ),
                ],
              ),
              onTap: () {
                viewDetails(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addMeal();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
