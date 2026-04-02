# Tightline News

A production-quality Flutter news reader that pulls live headlines from the [NewsAPI](https://newsapi.org) and presents them in an Apple News-inspired interface with smooth Hero animations, offline detection, and persistent caching.

Built as a portfolio piece demonstrating **Clean Architecture**, **BLoC state management**, **responsive design**, and **comprehensive testing**.

---

## Screenshots

|                      Feed (List)                      |      Feed (Grid)       |             Article Detail              |
| :---------------------------------------------------: | :--------------------: | :-------------------------------------: |
| Horizontal top‑story carousel + vertical article list | Two‑column grid toggle | Full‑bleed hero image with SliverAppBar |

---

## How to Run

### Prerequisites

| Tool          | Version                                             |
| ------------- | --------------------------------------------------- |
| Flutter SDK   | ≥ 3.8.1                                             |
| Dart          | ≥ 3.8.1 (bundled with Flutter)                      |
| A NewsAPI key | Free at [newsapi.org](https://newsapi.org/register) |

### Setup

```bash
# 1. Clone the repo
git clone https://github.com/<your-username>/tightline_news.git
cd tightline_news

# 2. Install dependencies
flutter pub get

# 3. Add your API key
cp app_config.example.yaml app_config.yaml
# Open app_config.yaml and replace YOUR_DEV_KEY_HERE with your key

# 4. Run code generation (DI & asset gen)
flutter pub run build_runner build --delete-conflicting-outputs

# 5. Launch the app
flutter run
```

### Run Tests

```bash
flutter test          # 62 tests across 10 test files
```

---

## Architecture

The project follows **Clean Architecture** with a clear separation of concerns:

```
lib/
├── app/                          # App shell, routing, theming
│   ├── app.dart                  # Root widget with MultiBlocProvider
│   ├── router.dart               # Named routes with fade transitions
│   └── theme/
│
├── core/                         # Shared infrastructure
│   ├── config/                   # YAML-based runtime config
│   ├── di/                       # Dependency injection (get_it + injectable)
│   ├── network/                  # Dio HTTP client, interceptors, connectivity
│   │   └── cubit/                # NetworkCubit — monitors online/offline
│   ├── ui/layout/                # Responsive sizing utilities
│   └── utils/                    # SnackbarUtils and pure helpers
│
└── features/news/                # Feature module
    ├── domain/                   # Business rules (no framework imports)
    │   ├── entities/             # NewsArticle data class
    │   └── repositories/        # Abstract ArticleRepository contract
    ├── data/                     # Implementation details
    │   ├── datasources/          # ArticleRemoteDataSource (Dio calls)
    │   └── repositories/        # ArticleRepositoryImpl
    └── presentation/             # UI layer
        ├── cubit/                # ArticleCubit (HydratedCubit)
        ├── screens/              # NewsFeedScreen, ArticleDetailScreen
        └── widgets/              # Reusable UI components
```

### Key Decisions

| Decision                            | Rationale                                                                                                                                                                                      |
| ----------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **BLoC / Cubit**                    | Predictable, testable state management with clear separation from UI. Chose Cubit over full Bloc for simplicity — no complex event mapping needed.                                             |
| **HydratedCubit**                   | Automatically persists and restores article data across app restarts, providing an instant-launch experience and offline-first caching with zero extra code.                                   |
| **Clean Architecture layers**       | Domain layer has no Flutter/Dio imports, making business logic portable and independently testable. Data layer can be swapped (e.g., from REST to GraphQL) without touching the cubit or UI.   |
| **Abstract repository interface**   | `ArticleRepository` is an abstract class in `domain/`; the concrete `ArticleRepositoryImpl` lives in `data/`. This enables easy mocking in tests and decouples the cubit from network details. |
| **get_it + injectable**             | Compile-time DI code generation eliminates manual service locator wiring and catches missing registrations at build time.                                                                      |
| **Responsive sizing**               | Custom `ResponsiveSize` utility scales all dimensions relative to a 390×844 design base, ensuring consistent layout across phone sizes without media query boilerplate.                        |
| **Graceful error handling**         | When a refresh fails but cached data exists, the app keeps showing the cached articles and surfaces the error as a non-blocking snackbar — never clears the user's screen.                     |
| **NetworkCubit**                    | Streams connectivity changes via `connectivity_plus` so the `OfflineBanner` widget reactively shows/hides without polling.                                                                     |
| **Named routes + PageRouteBuilder** | Enables custom fade transitions for the detail screen while keeping navigation declarative and testable.                                                                                       |

### Test Coverage

62 tests across 10 files covering:

- **Entity** — JSON serialization, deserialization, `fromCacheJson` round-trip, `_formatTimeAgo` edge cases
- **State** — `copyWith`, `hasMore`, sealed class hierarchy
- **Cubit** — Loading flows, silent refresh, error-with-cached-data preservation, hydration (`toJson`/`fromJson`)
- **Repository** — Success and error API response handling
- **Network** — `NetworkCubit` stream subscription, initial check, close/cleanup
- **Router** — Route generation, argument validation, error routes
- **Widgets** — `OfflineBanner` show/hide transitions, `StatusMessage` loading/error variants
- **Screen** — `NewsFeedScreen` list/grid toggle, error layout

---

## Tech Stack

| Category         | Library                                         |
| ---------------- | ----------------------------------------------- |
| Framework        | Flutter 3.8+ / Material 3                       |
| State Management | flutter_bloc, hydrated_bloc                     |
| DI               | get_it, injectable                              |
| HTTP             | Dio                                             |
| Connectivity     | connectivity_plus                               |
| Testing          | flutter_test, mocktail                          |
| Code Gen         | build_runner, injectable_generator, flutter_gen |

---

## NewsAPI Rate Limits

The app uses the [NewsAPI](https://newsapi.org) free developer tier, which has the following limits:

> **100 requests per 24 hours** (50 requests per 12-hour window)

When the limit is exceeded the API returns:

```json
{
  "status": "error",
  "code": "rateLimited",
  "message": "You have made too many requests recently. Developer accounts are limited to 100 requests over a 24 hour period (50 requests available every 12 hours). Please upgrade to a paid plan if you need more requests."
}
```

The app catches this response (`httpStatus 429` / `code: rateLimited`) in `ArticleRepositoryImpl` and surfaces the message **"Too many requests. Please wait a moment and try again."** to the user instead of the raw API text. Previously cached articles remain visible while the error is shown as a non-blocking snackbar.

To avoid hitting the limit during development, the app uses `HydratedCubit` to persist articles across sessions — so a fresh launch with cached data will not trigger an API call until the user pulls to refresh.

---

## License

This project is for portfolio/demonstration purposes.
