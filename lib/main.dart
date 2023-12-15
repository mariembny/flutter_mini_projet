import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Category.dart';
import 'firebase_options.dart';
import 'meals.dart';
import 'MealDetailsPage.dart';

void main() {
  InitFirebase();
  runApp(const MainApp());
}

Future<void> InitFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyForm();
  }
}

class _MyForm extends State<MyForm> {
  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  @override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Pour ajuster la taille du Column en fonction de son contenu
              children: [
                Text(
                  "Login to join Del Maria Ristorante",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailcontroller,
                  decoration: InputDecoration(
                    labelText: "Enter Email",
                    prefixIcon: Icon(Icons.person),
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty || !emailRegExp.hasMatch(val))
                      return ("Incorrect email");
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordcontroller,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Enter password",
                    prefixIcon: Icon(Icons.lock),
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      authentification(
                        context,
                        _emailcontroller.text,
                        _passwordcontroller.text,
                      );
                    }
                  },
                  icon: Icon(Icons.login),
                  label: Text("Sign IN"),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}


  authentification(BuildContext context, String emailAddress, password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Home();
      }));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("User not found")));
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Wrong password")));
      }
    }
  }
}


class CategoryCarde extends StatelessWidget {
  final String imag;
  final String title;
  final Category category;

  const CategoryCarde({required this.imag, required this.title, required this.category, Key? key}) : super(key: key);

  @override
Widget build(BuildContext context) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: ListTile(
      contentPadding: EdgeInsets.all(8.0), // Adjust content padding
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0), // Clip image border
        child: Image.network(
          imag,
          width: 80.0,
          height: 80.0,
          fit: BoxFit.cover,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIconButton(
            icon: Icons.create,
            color: Colors.blue,
            onPressed: () {
              _navigateToUpdate(context, category);
            },
          ),
          SizedBox(width: 8.0), // Add spacing between icons
          _buildIconButton(
            icon: Icons.remove_circle,
            color: Colors.red,
            onPressed: () {
              _DeleteConfirmationDialog(context, category);
            },
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetails(category: category),
          ),
        );
      },
    ),
  );
}

Widget _buildIconButton({
  required IconData icon,
  required Color color,
  required VoidCallback onPressed,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(30.0),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: color,
          size: 30.0,
        ),
      ),
    ),
  );
}

  void _navigateToUpdate(BuildContext context, Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateCategory(category: category),
      ),
    );
  }

  Future<void> _DeleteConfirmationDialog(BuildContext context, Category category) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do u want to delete this !!!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete Any way'),
              onPressed: () {
                //_deleteCat(context, category);
              },
            ),
          ],
        );
      },
    );
  }
}

class CreateCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        TextEditingController idControl = TextEditingController();
    TextEditingController nameControl = TextEditingController();
    TextEditingController imagUrlControl = TextEditingController();
    TextEditingController descriptionControl = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("ADD Category you want!!"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
             TextField(
              controller: idControl,
              decoration: InputDecoration(labelText: 'Category Id'),
            ),
            TextField(
              controller: nameControl,
              decoration: InputDecoration(labelText: 'Category Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: imagUrlControl,
              decoration: InputDecoration(labelText: 'Imag Url'),
            ),
            SizedBox(height: 16.0),
              TextField(
              controller: descriptionControl,
              decoration: InputDecoration(labelText: 'Category Descrip'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async{
                String id = idControl.text;
                String name = nameControl.text;
                String imagUrl = imagUrlControl.text;
                String description = descriptionControl.text;
                Map<String, String> data = {
                  "idCategory": id,
                  "strCategory": name,
                  "strCategoryThumb": imagUrl,
                  "strCategoryDescription": description,
                   };

    // Convert the map to JSON
    String jsonData = jsonEncode(data);

    // Send the POST request
    var response = await http.post(
      Uri.parse("http://192.168.56.1:3000/categories"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonData,
    );

    if (response.statusCode == 201) {
      // Successfully added the category
      print("Successfully added");
      
      // You can also handle further actions, e.g., navigate to another page
      Navigator.pop(context, jsonData);
    } else {
      // Failed to add the category
      print("Failed to add.code: ${response.statusCode}");
      // You might want to show an error message to the user
    }
  },
              child: Text("save"),
            ),
          ],
        ),
      ),
    );
  }
}


class UpdateCategory extends StatelessWidget {
  final Category category;

  const UpdateCategory({required this.category, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController idControl = TextEditingController(text: category.id);
    TextEditingController idCategoryControl = TextEditingController(text: category.idCategory);
    TextEditingController nameControl = TextEditingController(text: category.strCategory);
    TextEditingController imagUrlControl = TextEditingController(text: category.strCategoryThumb);
    TextEditingController descriptionControl = TextEditingController(text: category.strCategoryDescription);

    return Scaffold(
      appBar: AppBar(
        title: Text("Update ${category.strCategory}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
                TextField(
              controller: idCategoryControl,
              decoration: InputDecoration(labelText: 'Category Id'),
            ),
            TextField(
              controller: nameControl,
              decoration: InputDecoration(labelText: 'Category Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: imagUrlControl,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionControl,
              decoration: InputDecoration(labelText: 'Category Description'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String id = idControl.text;
                String idCategory = idCategoryControl.text;
                String name = nameControl.text;
                String imagUrl = imagUrlControl.text;
                String description = descriptionControl.text;

                Map<String, String> data = {
                  "id":id,
                  "idCategory": idCategory,
                  "strCategory": name,
                  "strCategoryThumb": imagUrl,
                  "strCategoryDescription": description,
                };

                String jsonData = jsonEncode(data);

                var response = await http.put(
                  Uri.parse("http://192.168.56.1:3000/categories/${category.id}"),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonData,
                );

                if (response.statusCode == 200) {
                  print("Successfully updated");

                  Navigator.pop(context, jsonData);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ),
                    );
                } else {
                  print("Failed to update.code: ${response.statusCode}");
                }
              },
              child: Text("save"),
            ),
          ],
        ),
      ),
    );
  }
}
class CategoryDetails extends StatelessWidget {
  final Category category;

  const CategoryDetails({required this.category, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Scaffold(
  appBar: AppBar(
    title: Text("Details"),
    leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  ),
  body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.strCategory,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Image.network(
            category.strCategoryThumb,
            height: 200.0, // Adjust the height as needed
          ),
          SizedBox(height: 10.0),
          Text(
            category.strCategoryDescription ?? "No description available",
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    ),
  ),
);
  }
}



class Home extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class CategoryList extends StatelessWidget {
  final List<Category> categoriesList;

  const CategoryList({required this.categoriesList, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categoriesList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryDetails(category: categoriesList[index]),
              ),
            );
          },
          child: CategoryCarde(
            imag: categoriesList[index].strCategoryThumb,
            title: categoriesList[index].strCategory,
            category: categoriesList[index]
          ),
        );
      },
    );
  }
}

class _HomePage extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Del Maria Ristorante"),
        elevation: 4.0, // Add elevation for a Material look
        backgroundColor: Color.fromARGB(255, 91, 183, 219), // Add a background color
      ),
      body: _getBodycat(_currentIndex),
      floatingActionButton: FloatingActionButton(
  onPressed: () => _CreateButton(),
  child: Icon(Icons.add),
  tooltip: 'Add Category',
  elevation: 8.0, // Add elevation for a Material look
  backgroundColor: Colors.blue, // Customize the background color
  splashColor: Colors.lightBlue, // Add a splash color when pressed
  heroTag: 'addCategory', // Provide a hero tag for hero animations
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0), // Customize the button shape
    // You can also use other shape classes like StadiumBorder, BeveledRectangleBorder, etc.
  ),
),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        backgroundColor: Color.fromARGB(255, 148, 204, 221),
        selectedItemColor: Colors.white,
        elevation: 8.0, // Add elevation for a Material look
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
            backgroundColor: Color.fromARGB(255, 91, 183, 219),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Meals',
            backgroundColor: Color.fromARGB(255, 91, 183, 219),
          ),
        ],
      ),
    );
  }


  Widget _getBodycat(int index) {
  switch (index) {
    case 0:
      return FutureBuilder<List<Category>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CategoryList(categoriesList: snapshot.data!);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return const CircularProgressIndicator();
        },
      );

    // case 1:
    //   return FutureBuilder<List<meal>>(
    //     future: fetchMeals(),
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         return MealsPage(mealsList: snapshot.data!);
    //       } else if (snapshot.hasError) {
    //         return Text("${snapshot.error}");
    //       }

    //       return const CircularProgressIndicator();
    //     },
    //   );

    default:
      return Container();
  }
}


  Future<List<Category>> fetchData() async {
    var response = await http.get(Uri.parse("http://192.168.56.1:3000/categories"));
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> json = jsonDecode(response.body).cast<Map<String, dynamic>>().toList();
      List<Category> cats = json.map((item) => Category.fromJson(item)).toList();
      return cats;
    } else {
      throw Exception("erreur !");
    }
  }

void _CreateButton() async {
  switch (_currentIndex) {
    case 0:
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateCategory()),
      );
      setState(() {});
      break;
  }
}
}