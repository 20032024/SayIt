import 'package:flutter/material.dart';
import 'package:project_sayit/screens/settings_screen.dart';
import 'package:project_sayit/screens/detail_screens.dart'; // Import the DetailScreen
import 'package:project_sayit/screens/lesson_screen.dart';
import 'custom_bottom_nav.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Proyecto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar section
            const TextField(
              decoration: InputDecoration(
                hintText: 'Buscar',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Filter buttons section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    child: const Text(
                      'TODO',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    child: const Text('EN CURSO'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    child: const Text('FINALIZADOS'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Categories content
            Expanded(
              child: ListView(
                children: [
                  _buildCategorySection(
                    context,
                    title: 'Animales',
                    items: 4,
                    // Pass a list of words or objects for this category
                    words: ['Cat', 'Dog', 'Lion', 'Tiger'],
                  ),
                  const SizedBox(height: 16),
                  _buildCategorySection(
                    context,
                    title: 'Frutas',
                    items: 4,
                    words: ['Manzana', 'Banana', 'Naranja', 'Fresa'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }

  Widget _buildCategorySection(
    BuildContext context, {
    required String title,
    required int items,
    required List<String> words, // Added words list as a parameter
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Ver más',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8,
          ),
          itemCount: items,
          itemBuilder: (context, index) {
            // Pass the data to the CategoryCard
            return CategoryCard(
              categoryName: title,
              progress: '1/20',
              word: words[index],
            );
          },
        ),
      ],
    );
  }
}

// CategoryCard now takes parameters for a better, dynamic flow
class CategoryCard extends StatelessWidget {
  final String categoryName;
  final String progress;
  final String word;

  const CategoryCard({
    super.key,
    required this.categoryName,
    required this.progress,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to DetailScreen, passing the required data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              categoryName: categoryName,
              progress: progress,
              description:
                  'This is a description for the ${categoryName.toLowerCase()} lesson.',
              word: word,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image space
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD54F),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 50, color: Color(0xFFC5AE79)),
                ),
              ),
            ),
            // Text content and progress bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word, // Use the word here
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    progress, // Use the progress here
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const LinearProgressIndicator(
                    value: 0.05,
                    backgroundColor: Color(0xFFF0F0F0),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    minHeight: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
