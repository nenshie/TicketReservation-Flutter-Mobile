import 'package:flutter/material.dart';
import '../widgets/global_button.dart';
import '../widgets/global_text_form.dart';
import '../utils/global_colors.dart';

class FilmsScreen extends StatefulWidget {
  const FilmsScreen({super.key});

  @override
  State<FilmsScreen> createState() => _FilmsScreenState();
}

class _FilmsScreenState extends State<FilmsScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final durationController = TextEditingController();
  final imageUrlController = TextEditingController();

  final List<String> _genres = ['Action', 'Drama', 'Comedy', 'Horror', 'Romance'];
  String? _selectedGenre;

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final movieData = {
        'title': titleController.text.trim(),
        'duration': durationController.text.trim(),
        'genre': _selectedGenre,
        'imageUrl': imageUrlController.text.trim(),
      };

      //print('Movie data: $movieData');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Movie added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Movie'),
        backgroundColor: GlobalColors.black,
      ),
      backgroundColor: GlobalColors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: GlobalColors.black,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 30,
                  spreadRadius: 5,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Movie',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (imageUrlController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            imageUrlController.text,
                            height: 180,
                            width: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(child: Text('Invalid image URL'));
                            },
                          ),
                        ),
                      ),
                    ),

                  GlobalTextForm(
                    controller: titleController,
                    obscure: false,
                    text: 'Movie Title',
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the movie title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  GlobalTextForm(
                    controller: durationController,
                    obscure: false,
                    text: 'Duration (in minutes)',
                    textInputType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the movie duration';
                      } else if (int.tryParse(value.trim()) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    value: _selectedGenre,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGenre = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Genre',
                      labelStyle: TextStyle(color: GlobalColors.red),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      filled: true,
                      fillColor: GlobalColors.darkGrey,
                    ),
                    items: _genres.map((genre) {
                      return DropdownMenuItem<String>(
                        value: genre,
                        child: Text(
                          genre,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a genre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  GlobalTextForm(
                    controller: imageUrlController,
                    obscure: false,
                    text: 'Image URL',
                    textInputType: TextInputType.url,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the image URL';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  Center(
                    child: GlobalButton(
                      text: 'Add Movie',
                      onPressed: _submit,
                      backgroundColor: GlobalColors.red,
                      textColor: GlobalColors.black,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
