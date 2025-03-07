  import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/constant/color_constant.dart';
import 'package:task/project_specific/text_theme.dart';


  class MoviesScreen extends StatefulWidget {
    const MoviesScreen({super.key});

    @override
    State<MoviesScreen> createState() => _MoviesScreenState();
  }

  class _MoviesScreenState extends State<MoviesScreen> {
    final List<String> _playlists = [];
    final List<String> _categories = ["movie".tr, "episode".tr, "video".tr];

    @override
    Widget build(BuildContext context) {
      return DefaultTabController(
        length: _categories.length,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text(
              "playlists".tr,
              style: AppTextTheme.medium.copyWith(color: ColorConstant.whiteColor),
            ),
            backgroundColor: Colors.black,
            actions: [
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: ColorConstant.primary),
                onPressed: _showCreatePlaylistDialog,
                tooltip: "create_new_playlist".tr,
              ),
              IconButton(
                icon: Icon(Icons.settings, color: ColorConstant.whiteColor),
                onPressed: _showManageCategoriesDialog,
                tooltip: "manage_categories".tr,
              ),
            ],
            bottom: TabBar(
              indicatorColor: ColorConstant.primary,
              labelColor: ColorConstant.whiteColor,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              tabs: _categories.map((category) => Tab(text: category)).toList(),
            ),
          ),
          body: TabBarView(
            children: [
              _playlists.isEmpty ? _buildEmptyState() : _buildPlaylistList(),
              const EpisodesScreen(),
              const VideoScreen(),
            ],
          ),
        ),
      );
    }

    /// **Manage Categories Dialog**
    void _showManageCategoriesDialog() {
      TextEditingController categoryController = TextEditingController();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("manage_categories".tr, style: AppTextTheme.bold),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ..._categories.map((category) => ListTile(
                  title: Text(category, style: AppTextTheme.medium),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: _categories.length > 1
                        ? () {
                      setState(() {
                        _categories.remove(category);
                      });
                      Navigator.pop(context);
                      _showManageCategoriesDialog(); // Refresh dialog
                    }
                        : null,
                  ),
                )),
                const SizedBox(height: 10),
                TextField(
                  controller: categoryController,
                  style: AppTextTheme.medium,
                  decoration: InputDecoration(
                    hintText: "new_category".tr,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[900],
                  ),
                ),
              ],
            ),
            actions: [
              _dialogButton("close".tr, () => Navigator.pop(context), Colors.grey),
              _dialogButton("add".tr, () {
                if (categoryController.text.trim().isNotEmpty) {
                  setState(() {
                    _categories.add(categoryController.text.trim());
                  });
                  Navigator.pop(context);
                }
              }, ColorConstant.primary),
            ],
          );
        },
      );
    }

    /// **Create Playlist Dialog**
    void _showCreatePlaylistDialog() {
      TextEditingController playlistController = TextEditingController();
      String selectedCategory = _categories.first;

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("create_new_playlist".tr, style: AppTextTheme.bold.copyWith(fontSize: 20)),
                const SizedBox(height: 15),
                _customTextField(playlistController, "playlist_name".tr),
                const SizedBox(height: 15),
                _categoryDropdown(selectedCategory, (String? newValue) {
                  setState(() => selectedCategory = newValue!);
                }),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _dialogButton("cancel".tr, () => Navigator.pop(context), Colors.grey),
                    _dialogButton("create".tr, () {
                      if (playlistController.text.trim().isNotEmpty) {
                        setState(() {
                          _playlists.add("${playlistController.text.trim()} ($selectedCategory)");
                        });
                        Navigator.pop(context);
                      }
                    }, ColorConstant.primary),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    /// **Empty Playlist State**
    Widget _buildEmptyState() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.playlist_add, size: 80, color: Colors.white30),
            const SizedBox(height: 10),
            Text(
              "create_playlist".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ],
        ),
      );
    }

    /// **Playlist List**
    Widget _buildPlaylistList() {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: _playlists.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              title: Text(_playlists[index], style: const TextStyle(color: Colors.white, fontSize: 18)),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deletePlaylist(index),
              ),
            ),
          );
        },
      );
    }

    /// **Delete Playlist**
    void _deletePlaylist(int index) {
      setState(() {
        _playlists.removeAt(index);
      });
    }

    /// **Custom Styled TextField**
    Widget _customTextField(TextEditingController controller, String hint) {
      return TextField(
        controller: controller,
        style: AppTextTheme.medium.copyWith(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[900],
        ),
      );
    }

    /// **Custom Category Dropdown**
    Widget _categoryDropdown(String selectedCategory, Function(String?) onChanged) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedCategory,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            style: AppTextTheme.medium.copyWith(fontSize: 16, color: Colors.white),
            dropdownColor: Colors.black,
            items: _categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      );
    }

    /// **Reusable Dialog Button**
    Widget _dialogButton(String text, VoidCallback onPressed, Color color) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: color),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      );
    }
  }

  // Placeholder screens
  class EpisodesScreen extends StatelessWidget {
    const EpisodesScreen({super.key});
    @override
    Widget build(BuildContext context) => Center(child: Text("episode".tr, style: TextStyle(color: Colors.white)));
  }

  class VideoScreen extends StatelessWidget {
    const VideoScreen({super.key});
    @override
    Widget build(BuildContext context) => Center(child: Text("video".tr, style: TextStyle(color: Colors.white)));
  }
