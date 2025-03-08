# 🐦 BlogBird

**BlogBird** is a modern, feature-rich **blogging app** built with **Flutter**. It uses **Supabase** as the backend for authentication, database, and storage, while **BLoC** handles state management efficiently.

## 🚀 Features

✅ **User Authentication** – Sign up, sign in, and manage user sessions with Supabase Auth  
✅ **Create, Read, Update, Delete (CRUD) Blogs** – Manage blog posts easily  
✅ **Rich Text Editor** – Write engaging posts with a beautiful editor  
✅ **Image Upload & Storage** – Upload blog cover images using Supabase Storage  
✅ **Real-time Updates** – Sync blog posts instantly across devices   
✅ **BLoC for State Management** – Ensuring scalability and performance

## 📸 Screenshots

| Signup Screen                     | Blog Post                      |  
|-----------------------------------|--------------------------------| 
| ![Signup](screenshots/signup.png) | ![Blog](screenshots/blogs.png) |  

## 🛠 Installation

### Prerequisites
- Flutter (latest stable version)
- Dart SDK
- Supabase account & project

### Clone the Repository
```sh  
git clone https://github.com/AdilMulimani/blog_bird 
cd blogbird  
```  

### Install Dependencies
```sh  
flutter pub get  
```  

### Configure Supabase
1. Create a project on [Supabase](https://supabase.io/)
2. Copy your **Supabase URL** and **API key**
3. Add them to `.env` or `lib/core/constants.dart`
```dart  
const String supabaseUrl = 'your-supabase-url';  
const String supabaseAnonKey = 'your-api-key';  
```  

### Run the App
```sh  
flutter run  
```  

## 🏗 Technologies Used

- **Flutter** – UI framework
- **Dart** – Programming language
- **Supabase** – Backend, authentication, database
- **BLoC** – State management

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`feature/new-feature`)
3. Commit your changes
4. Push to your branch
5. Open a pull request

## 📩 Contact

📧 **Email**: adilmulimani@gmail.com  


---

⭐ **Give a star if you like this project!** 🚀  
