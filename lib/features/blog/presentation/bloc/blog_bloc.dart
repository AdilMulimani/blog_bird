import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/blog.dart';
import '../../domain/usecases/get_all_blogs.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({required UploadBlog uploadBlog, required GetAllBlogs getAllBlogs})
      : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(BlogLoading());
    });

    on<BlogUpload>(_onBlogUpload);

    on<BlogGetAllBlogs>(_onGetAllBlogs);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final Either<Failure, Blog> res = await _uploadBlog(UploadBlogParams(
      posterId: event.posterId,
      title: event.title,
      content: event.content,
      image: event.image,
      topics: event.topics,
    ));

    res.fold((Failure failure) => emit(BlogFailure(error: failure.message)),
        (Blog blog) => emit(BlogUploadSuccess()));
  }

  void _onGetAllBlogs(BlogGetAllBlogs event, Emitter<BlogState> emit) async {
    final Either<Failure, List<Blog>> res = await _getAllBlogs(NoParams());
    res.fold((Failure failure) => emit(BlogFailure(error: failure.message)),
        (List<Blog> blogs) => emit(BlogDisplaySuccess(blogs)));
  }
}
