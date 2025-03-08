import 'package:blog_app/core/common/cubits/app_user_cubit.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_implementation.dart';
import 'package:blog_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/repositories/blog_repository_implementation.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/domain/usecases/user_sign_in.dart';

//global instance of get it
final GetIt serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  //initialise supabase
  final Supabase supaBase = await Supabase.initialize(
      url: dotenv.env['URL'].toString(),
      anonKey: dotenv.env['ANON_KEY'].toString());

  //singleton of Supabase client
  serviceLocator.registerLazySingleton(() => supaBase.client);

  //core
  serviceLocator.registerLazySingleton<AppUserCubit>(() => AppUserCubit());

  //initialize auth
  _initAuth();
  //initialize blog
  _initBLog();
}

void _initAuth() {
  serviceLocator
    //internet connection
    ..registerFactory<InternetConnection>(() => InternetConnection())
    //connection checker
    ..registerFactory<ConnectionChecker>(() => ConnectionCheckerImplementation(
        internetConnection: serviceLocator<InternetConnection>()))
    //auth remote data source
    ..registerFactory<AuthRemoteDataSource>(() =>
        AuthRemoteDataSourceImplementation(
            supabaseClient: serviceLocator<SupabaseClient>()))
    //auth repository
    ..registerFactory<AuthRepository>(() => AuthRepositoryImplementation(
        connectionChecker: serviceLocator(),
        authRemoteDataSource: serviceLocator<AuthRemoteDataSource>()))
    //use cases
    ..registerFactory(
        () => UserSignUp(authRepository: serviceLocator<AuthRepository>()))
    ..registerFactory(
        () => UserSignIn(authRepository: serviceLocator<AuthRepository>()))
    ..registerFactory(
        () => CurrentUser(authRepository: serviceLocator<AuthRepository>()))
    // singleton bloc
    ..registerLazySingleton<AuthBloc>(() => AuthBloc(
        userSignUp: serviceLocator<UserSignUp>(),
        userSignIn: serviceLocator<UserSignIn>(),
        currentUser: serviceLocator<CurrentUser>(),
        appUserCubit: serviceLocator<AppUserCubit>()));
}

void _initBLog() {
  //blog remote data source
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(() =>
        BlogRemoteDataSourceImplementation(
            supabaseClient: serviceLocator<SupabaseClient>()))

    //blog repository
    ..registerFactory<BlogRepository>(() => BlogRepositoryImplementation(
        connectionChecker: serviceLocator<ConnectionChecker>(),
        blogRemoteDataSource: serviceLocator<BlogRemoteDataSource>()))
    //use cases
    ..registerFactory<UploadBlog>(
        () => UploadBlog(blogRepository: serviceLocator<BlogRepository>()))
    ..registerFactory<GetAllBlogs>(
        () => GetAllBlogs(blogRepository: serviceLocator<BlogRepository>()))
    //singleton bloc
    ..registerLazySingleton<BlogBloc>(() => BlogBloc(
        uploadBlog: serviceLocator<UploadBlog>(),
        getAllBlogs: serviceLocator<GetAllBlogs>()));
}
