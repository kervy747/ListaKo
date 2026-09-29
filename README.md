# ListaKo

**ListaKo** is a Flutter grocery list application designed to help users
create, organize, and manage their grocery lists in one place.

The name **ListaKo** comes from the Filipino words **"lista"** and
**"ko."**

-   **Lista** means **list**.
-   **Ko** means **my** or **mine**.

Together, **ListaKo** represents **"My List"** --- a simple name that
reflects the purpose of the application: a personal place where users
can create and manage their own grocery lists.

## Features

-   User registration and login
-   Firebase Authentication
-   Create multiple grocery lists
-   Add, edit, and delete grocery items
-   Mark grocery items as checked
-   Organize items by category
-   Sort grocery items by:
    -   Oldest
    -   Newest
    -   Category
-   Set a budget for each grocery list
-   Calculate item totals and overall list total
-   Track remaining budget
-   Show when a list goes over budget
-   Copy a grocery list as text
-   Multiple currency options
-   User profile management
-   Change profile name
-   Upload and update profile picture
-   Change password
-   Password strength indicator
-   Firebase Firestore data storage
-   Cloudinary image storage
-   Responsive Material 3 interface

## Grocery Categories

ListaKo currently supports the following grocery categories:

-   Fruits & Vegetables
-   Meat & Poultry
-   Dairy & Eggs
-   Bakery
-   Beverages
-   Snacks
-   Household
-   Others

## Supported Currencies

The application includes:

-   PHP --- Philippine Peso
-   USD --- US Dollar
-   EUR --- Euro
-   GBP --- British Pound
-   JPY --- Japanese Yen
-   KRW --- South Korean Won
-   AUD --- Australian Dollar
-   CAD --- Canadian Dollar
-   SGD --- Singapore Dollar
-   INR --- Indian Rupee

The default currency is **PHP (₱)**.

## Project Structure

The project follows a simple separation between models, controllers,
views, and services.

``` text
lib/
├── main.dart
├── firebase_options.dart
│
├── models/
│   ├── currency.dart
│   ├── grocery_item.dart
│   └── grocery_list.dart
│
├── controllers/
│   ├── change_password_controller.dart
│   ├── currency_controller.dart
│   ├── edit_profile_controller.dart
│   ├── home_controller.dart
│   ├── list_detail_controller.dart
│   ├── login_controller.dart
│   ├── profile_controller.dart
│   └── register_controller.dart
│
├── services/
│   └── cloudinary_service.dart
│
└── views/
    ├── auth/
    │   ├── login_screen.dart
    │   └── register_screen.dart
    │
    ├── home/
    │   ├── add_list_sheet.dart
    │   ├── grocery_list_card.dart
    │   ├── home_header.dart
    │   └── home_screen.dart
    │
    ├── listing/
    │   ├── add_item_sheet.dart
    │   ├── budget_dialog.dart
    │   ├── grocery_item_tile.dart
    │   ├── list_detail_screen.dart
    │   └── list_summary_card.dart
    │
    ├── profile/
    │   ├── change_password_screen.dart
    │   ├── edit_profile_screen.dart
    │   └── profile_screen.dart
    │
    ├── theme/
    │   ├── app_colors.dart
    │   └── category_style.dart
    │
    └── widgets/
        ├── currency_picker_sheet.dart
        ├── empty_state.dart
        ├── stat_card.dart
        └── user_avatar.dart
```

## Folder Responsibilities

### `models/`

Contains the data structures used by the application.

-   `GroceryItem` represents an individual grocery item.
-   `GroceryList` represents a grocery list and its items.
-   `currency.dart` contains the supported currency information.

### `controllers/`

Contains the application's main logic and state management.

Examples:

-   `LoginController` handles user login.
-   `RegisterController` handles account registration.
-   `HomeController` manages grocery lists on the home screen.
-   `ListDetailController` manages items, sorting, budgets, totals, and
    list persistence.
-   `CurrencyController` manages the selected currency.
-   `ProfileController` handles user profile information.
-   `EditProfileController` handles profile updates and profile image
    uploads.
-   `ChangePasswordController` handles password validation and password
    changes.

The controllers use `ChangeNotifier` to notify the UI when data changes.

### `views/`

Contains the user interface of ListaKo.

The screens are grouped by purpose:

-   `auth/` --- login and registration
-   `home/` --- grocery list dashboard
-   `listing/` --- grocery list and item management
-   `profile/` --- profile and account settings
-   `theme/` --- colors and category styling
-   `widgets/` --- reusable UI components

### `services/`

Contains external service-related logic.

`CloudinaryService` handles uploading profile images to Cloudinary and
preparing optimized avatar image URLs.

## Data Flow

A simplified flow of the application is:

``` text
User
  ↓
Views / UI
  ↓
Controllers
  ↓
Models
  ↓
Firebase Authentication / Firestore
  ↓
Cloudinary (profile images)
```

For example, when a user adds a grocery item:

``` text
AddItemSheet
     ↓
ListDetailController
     ↓
GroceryItem
     ↓
GroceryList
     ↓
Firestore
```

## Firebase

ListaKo uses Firebase for its backend functionality.

### Firebase Authentication

Firebase Authentication is used for:

-   Account registration
-   Login
-   Logout
-   Password re-authentication
-   Password changes
-   User profile name
-   User profile photo URL

### Cloud Firestore

Grocery lists are stored under the authenticated user's account.

The structure used by the application is approximately:

``` text
users
└── {userId}
    ├── currencyCode
    └── lists
        └── {listId}
            ├── id
            ├── name
            ├── budget
            ├── createdAt
            └── items
                ├── id
                ├── name
                ├── category
                ├── quantity
                ├── price
                └── isChecked
```

Each user's lists are separated using their Firebase Authentication UID.

## Cloudinary

Cloudinary is used for profile image uploads.

Profile images are uploaded through the `CloudinaryService`, and the
resulting image URL is saved to the user's Firebase Authentication
profile.

## Application Flow

### 1. Login / Registration

The application starts at the login screen.

Users can:

-   Log in using email and password.
-   Create a new account.
-   Continue to the home screen after successful authentication.

### 2. Home Screen

The home screen displays the user's grocery lists and summary
information.

Users can:

-   Create a new grocery list.
-   Open an existing list.
-   Delete a list.
-   Change the application's currency.
-   Open their profile.

### 3. Grocery List

Inside a list, users can:

-   Add grocery items.
-   Edit grocery items.
-   Delete grocery items.
-   Check or uncheck items.
-   Sort items.
-   Set or change the list budget.
-   View total spending.
-   Copy the list as text.

### 4. Profile

The profile section allows users to:

-   View their account information.
-   Edit their name.
-   Change their profile picture.
-   Change their password.

## Technologies Used

-   **Flutter** --- mobile application framework
-   **Dart** --- programming language
-   **Firebase Authentication** --- account authentication
-   **Cloud Firestore** --- cloud database
-   **Cloudinary** --- profile image storage
-   **Material 3** --- UI design system

## Architecture

ListaKo uses a lightweight architecture that separates the application
into:

``` text
Models       → Data
Controllers  → Logic and state
Views        → User interface
Services     → External services
```

This separation helps keep the UI code cleaner while allowing the
application's logic and data structures to be maintained separately.

## Getting Started

### Prerequisites

Make sure you have:

-   Flutter SDK installed
-   Dart SDK
-   Android Studio or another Flutter-supported IDE
-   A Firebase project
-   A Cloudinary account configured for image uploads

### Installation

Clone or download the project and install the dependencies:

``` bash
flutter pub get
```

Make sure the Firebase configuration is properly set up for the target
platform.

Then run:

``` bash
flutter run
```

## Notes

The provided project source is centered around the `lib/` directory. The
complete runnable project also requires the project's Flutter
configuration files, dependency configuration, and Firebase setup.

Do not expose private Firebase or Cloudinary credentials when sharing
the project publicly.

## Project Purpose

ListaKo was created to provide a simple and personal way of managing
grocery lists.

Instead of having grocery items scattered across notes or messages,
users can keep their lists together, add prices and quantities, set a
budget, and check items as they shop.

**ListaKo --- "My List."**
