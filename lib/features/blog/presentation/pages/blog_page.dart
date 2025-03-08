import 'package:blog_app/core/common/widgets/custom_loading_indicator.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/blog.dart';
import '../bloc/blog_bloc.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    context.read<BlogBloc>().add(BlogGetAllBlogs());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppPalette.transparentColor,
        title: const Text('Blog App'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                context.push('/add-new-blog-page');
              },
              icon: const Icon(
                CupertinoIcons.add_circled,
              )),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const CustomLoadingIndicator();
          }
          if (state is BlogDisplaySuccess) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final Blog blog = state.blogs[index];
                return BlogCard(
                  blog: blog,
                  color: index % 2 == 0
                      ? AppPalette.gradient1
                      : AppPalette.gradient2,
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
