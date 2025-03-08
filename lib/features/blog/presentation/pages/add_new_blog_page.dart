import 'dart:io';

import 'package:blog_app/core/common/cubits/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/custom_loading_indicator.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  List<String> selectedTopics = [];

  File? image;

  void selectImage() async {
    final File? pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _uploadBlog() {
    if (_formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final postedId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(BlogUpload(
            posterId: postedId,
            title: titleController.text.trim().toString(),
            content: contentController.text.trim().toString(),
            image: image!,
            topics: selectedTopics,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Blog'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => _uploadBlog(),
              icon: const Icon(
                CupertinoIcons.check_mark_circled,
              )),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error.toString());
          } else if (state is BlogUploadSuccess) {
            showSnackBar(context, 'Blog Uploaded Successfully!');
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const CustomLoadingIndicator();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: DottedBorder(
                                color: AppPalette.borderColor,
                                dashPattern: const [10, 8],
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(16.0),
                                strokeCap: StrokeCap.round,
                                child: Container(
                                  height: MediaQuery.sizeOf(context).height / 5,
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(24),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 40,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Select your image',
                                        style: TextStyle(fontSize: 16),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          'Technology',
                          'Business',
                          'Programming',
                          'Entertainment'
                        ]
                            .map((String topic) => Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!selectedTopics.contains(topic)) {
                                        selectedTopics.add(topic);
                                      } else {
                                        selectedTopics.remove(topic);
                                      }
                                      setState(() {});
                                      debugPrint(selectedTopics.toString());
                                    },
                                    child: Chip(
                                      label: Text(topic),
                                      color: WidgetStatePropertyAll(
                                        selectedTopics.contains(topic)
                                            ? AppPalette.gradient2
                                            : AppPalette.transparentColor,
                                      ),
                                      side: BorderSide(
                                        color: selectedTopics.contains(topic)
                                            ? AppPalette.transparentColor
                                            : AppPalette.borderColor,
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlogEditor(
                        textEditingController: titleController,
                        hintText: 'Blog Title'),
                    const SizedBox(height: 10),
                    BlogEditor(
                        textEditingController: contentController,
                        hintText: 'Blog Content'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
