# Tightline News

A Flutter news reader. It pulls live headlines from [NewsAPI](https://newsapi.org) and displays them in a clean, Apple News-inspired interface with a top-story carousel, list/grid toggle, offline support, and caching between sessions.

---

## Getting Started

### Prerequisites

- Flutter SDK **≥ 3.8.1** — [install guide](https://docs.flutter.dev/get-started/install)
- A free NewsAPI key — [register here](https://newsapi.org/register)

### Setup

```bash
# 1. Clone the repo
git clone https://github.com/oyen-bright/tightline_news.git
cd tightline_news

# 2. Install dependencies
flutter pub get

# 3. Copy the config template and add your API key
cp app_config.example.yaml app_config.yaml
```

Open `app_config.yaml` and replace `YOUR_DEV_KEY_HERE` with your NewsAPI key:

```yaml
dev:
  baseUrl: https://newsapi.org/v2/
  apiKey: YOUR_KEY_HERE
```

```bash
# 4. Run the app
flutter run
```

A `Makefile` is included as a shortcut for common commands:

```bash
make pub_get       # install dependencies
make build_runner  # regenerate code (only needed after annotation changes)
make test          # run tests
make test_coverage # run tests with coverage
```

### Run Tests

```bash
make test
# or: flutter test
```

Tests cover the full stack data, state, networking, routing, and UI with no real network calls made during testing.

---

## Architecture

The project is structured around **Clean Architecture**: the UI has no knowledge of the network, and the networking code has no knowledge of the UI. Each piece can be changed or tested independently.

```
lib/
├── app/          # Root widget, routing, theme
├── core/         # Networking, dependency injection, config
└── features/
    └── news/
        ├── domain/        # Data models and repository contract
        ├── data/          # API calls and repository implementation
        └── presentation/  # State management, screens, widgets
```

### Key Decisions

**Separation of concerns**
The app is split into clear layers. Business logic lives in the domain layer with no Flutter or network dependencies, this makes it easy to test and easy to change. Swapping the API for a different data source, for example, only touches the data layer.

**Offline-first caching**
Articles are saved to disk automatically after each successful fetch. When the user opens the app  even with no internet connection they see the last articles immediately rather than a blank loading screen. When connectivity returns, the list refreshes silently in the background.

**State management**
All UI state flows through a single state object: loading, loaded, or error. The screen simply reacts to whichever state is current. If a refresh fails but articles are already cached, the cached list stays on screen and a small error banner appears the screen is never blanked out by a network error.

**Testable networking**
The API layer sits behind an abstract interface, so tests can inject a fake implementation instead of making real network calls. This keeps tests fast and free of external dependencies.

**Dependency injection**
Each class declares what it needs, and a central setup file wires everything together at startup. This keeps individual classes small and focused.

---

## Tech Stack

| Category         | Library                     |
| ---------------- | --------------------------- |
| Framework        | Flutter 3.8+ / Material 3   |
| State Management | flutter_bloc, hydrated_bloc |
| Networking       | Dio                         |
| Connectivity     | connectivity_plus           |
| Testing          | flutter_test, mocktail      |

---

## NewsAPI Rate Limits

The free tier has two limits worth knowing:

- **100 requests per day** — if hit, the app shows *"Too many requests. Please wait a moment and try again."* while keeping any cached articles visible. Because articles are saved between sessions, a cold launch with cached data doesn't count as a request — the API is only called when the user explicitly pulls to refresh.
- **100 results per query** — the free tier won't return more than 100 articles per endpoint call, regardless of how many exist. The app respects this by stopping pagination at 100 articles so it never requests a page that would exceed the limit.
