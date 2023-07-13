import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe APP Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RecipeScreen(),
    );
  }
}

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  List<dynamic> Recipes = [];

  Future fetchrecipe() async {
    final response = await http.get(Uri.parse(
        'https://api.edamam.com/search?q=vegetable&app_id=166f88cc&app_key=14530b3d9f8903c7b5b91274db72c713&from=0&to=100&calories=591-722&health=alcohol-free'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        Recipes = data['hits'];
      });
    } else {
      setState(() {
        Recipes = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Recipe App Demo',
          style: GoogleFonts.poppins(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder(
              future: fetchrecipe(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: Recipes.length,
                  itemBuilder: (context, index) {
                    final Recipe = Recipes[index]['recipe'];
                    return ListTile(
                      leading: Image.network(
                        Recipe['image'],
                        width: 60,
                        height: 80,
                      ),
                      title: Text(
                        Recipe['label'],
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          Recipe['healthLabels'] != null
                              ? Recipe['healthLabels'][0]
                              : 'data not available',
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
