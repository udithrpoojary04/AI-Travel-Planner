# PROJECT REPORT

## SMART AI TRAVEL PLANNER & EXPENSE MANAGEMENT SYSTEM
**A Cross-Platform Mobile Application Built with Flutter, Clean Architecture, and Retrieval-Augmented Generation (RAG)**

---

### TABLE OF CONTENTS
1. Title and Project Overview
2. Introduction
   - 2.1 Background
   - 2.2 Problem Statement
   - 2.3 Objectives of the Project
   - 2.4 Scope of the Application
3. Technology Stack
   - 3.1 Mobile Framework & Language
   - 3.2 Architectural Pattern & State Management
   - 3.3 Backend Services & Authentication
   - 3.4 Artificial Intelligence & RAG Integration
   - 3.5 External APIs & Geolocation Services
   - 3.6 Local Database & Caching
   - 3.7 Data Visualization & Document Generation
4. System Architecture and Working
   - 4.1 System Architectural Design (Clean Architecture)
   - 4.2 Step-by-Step Working Mechanism
     - 4.2.1 User Authentication and Profile Setup
     - 4.2.2 Trip Creation and User Preference Capture
     - 4.2.3 Retrieval-Augmented Generation (RAG) Pipeline
     - 4.2.4 Real-time Weather and Geospatial Mapping
     - 4.2.5 Itinerary Display and Activity Tracking
     - 4.2.6 Dynamic Expense Tracking & Budget Analytics
     - 4.2.7 Offline Persistence and PDF Export
5. Modules and Functional Requirements
   - 5.1 Authentication Module
   - 5.2 Trip Management Module
   - 5.3 AI Recommendation Engine Module
   - 5.4 Weather & Maps Module
   - 5.5 Expense & Budget Tracker Module
   - 5.6 Document Export Module
6. Conclusion and Future Scope
   - 6.1 Conclusion
   - 6.2 Key Challenges Faced & Solutions
   - 6.3 Future Enhancements

---

### 1. TITLE AND PROJECT OVERVIEW

- **Project Title:** Smart AI Travel Planner & Expense Management Mobile Application
- **Domain:** Mobile Application Development, Artificial Intelligence (LLM & RAG), Location-Based Services, Personal Finance Management
- **Platform:** Cross-Platform Mobile Application (Android & iOS)
- **Primary Framework:** Flutter (Dart SDK ^3.12.2)

---

### 2. INTRODUCTION

#### 2.1 Background
Travel planning has traditionally been a time-consuming, fragmented, and tedious process. A traveler typically has to browse multiple independent websites and applications: travel blogs for recommendations, review platforms for hotels and restaurants, weather portals for forecasts, map services for navigation, and spreadsheets for budget tracking. Because these tools are disconnected, travelers often face disorganized plans, inaccurate travel schedules, and overspending.

With recent developments in Large Language Models (LLMs), automated itinerary creation has become possible. However, generic LLMs frequently suffer from factual hallucinations—recommending closed businesses, fabricated hotels, or geographically impractical schedules. This project addresses these challenges by developing a unified mobile application that combines generative AI with verified real-world geospatial and historical data using a Retrieval-Augmented Generation (RAG) pipeline.

#### 2.2 Problem Statement
1. **Information Fragmentation:** Planning a trip requires toggling between search engines, booking platforms, weather services, mapping tools, and personal note-taking apps.
2. **AI Hallucinations in Travel:** Standalone LLMs often invent non-existent places, restaurants, and hotels, giving travelers misleading recommendations.
3. **Lack of In-Trip Financial Control:** Travelers often lose track of daily expenses across categories such as food, lodging, and activities, leading to budget overruns.
4. **Poor Offline Support:** Many modern travel apps become unusable without active internet connectivity, leaving travelers stranded in areas with weak cellular coverage.

#### 2.3 Objectives of the Project
- To design and build a responsive, user-friendly cross-platform mobile application using Flutter.
- To implement Clean Architecture and BLoC (Business Logic Component) pattern for maintainable, testable, and decoupled code.
- To eliminate AI hallucinations by grounding an open LLM (via Groq API) with real-world geospatial points of interest (Geoapify API) and verified local landmarks (Wikipedia REST API).
- To provide integrated travel tools including real-time weather forecasting (OpenWeatherMap API) and interactive OpenStreetMap navigation.
- To build a comprehensive expense tracking and budget dashboard with visual chart analytics using FL Chart.
- To implement reliable offline caching with Hive local database and allow downloadable PDF itinerary generation.

#### 2.4 Scope of the Application
The application provides end-to-end support for a traveler's journey:
- **Pre-Trip:** User authentication, destination selection, date range specification, budget entry, travel interest selection, automated RAG-based itinerary generation, and weather forecasting.
- **On-Trip:** Interactive daily activity schedules, location mapping, live expense logging with category segregation, and real-time budget depletion calculation.
- **Post-Trip / Archival:** Offline access to all saved trips and expenses, as well as exportable, print-ready PDF trip reports.

---

### 3. TECHNOLOGY STACK

The project is developed using modern, industry-standard tools and frameworks:

#### 3.1 Mobile Framework & Programming Language
- **Flutter (SDK ^3.12.2):** Google's open-source UI software development kit. It enables compilation to native ARM/x86 machine code for both Android and iOS from a single Dart codebase.
- **Dart:** Strongly typed, object-oriented language optimized for client applications with ahead-of-time (AOT) and just-in-time (JIT) compilation.

#### 3.2 Architecture & State Management
- **Clean Architecture:** Divided into three layers—Domain (Business logic, Entities, Use Cases), Data (Models, Data Sources, Repositories), and Presentation (UI, BLoC, Widgets).
- **flutter_bloc (^9.1.1):** Predictable state management library separating business logic from presentation through explicit Events and States.
- **GetIt (^9.2.1):** Service locator for dependency injection, decoupling implementations from interfaces across layers.
- **Equatable (^2.1.0):** Simplifies object comparisons by value rather than reference, preventing unnecessary UI rebuilds.
- **GoRouter (^17.3.0):** Declarative, URL-driven routing system supporting nested navigation, deep-linking, and clean parameter passing.

#### 3.3 Backend Services & Authentication
- **Firebase Core (^4.12.1):** Central backend infrastructure integration.
- **Firebase Authentication (^6.5.6):** Secure user authentication supporting Email/Password registration/login and Google Sign-In.
- **Cloud Firestore (^6.7.1):** Cloud-hosted NoSQL document database for remote profile and trip synchronization.

#### 3.4 Artificial Intelligence & RAG Pipeline
- **Groq Cloud API (Llama-3.3-70b-versatile):** Ultra-low-latency inference engine serving Meta’s 70-billion-parameter open weights model.
- **Retrieval-Augmented Generation (RAG):** Dynamic prompt augmentation using live fetched API data to ground the LLM in real-world facts.

#### 3.5 External APIs & Geolocation
- **Geoapify Places API:** Fetches verified, physically existing hotels, restaurants, and landmarks with precise names and geographic coordinates.
- **Wikipedia REST API:** Retrieves official historical extracts and verified local landmarks for the target destination.
- **OpenWeatherMap API:** Live meteorological forecasts including current temperature, weather conditions, and atmospheric descriptions.
- **flutter_map (^7.0.2) & latlong2 (^0.9.0):** Interactive, open-source OpenStreetMap rendering engine for mobile displays.
- **Geolocator (^14.0.3):** Device GPS coordinate retrieval.

#### 3.6 Local Database & Caching
- **Hive & Hive Flutter (^2.2.3 / ^1.1.0):** Fast, lightweight, key-value NoSQL database written in pure Dart with binary serialization (via custom TypeAdapters for `TripModel`, `ExpenseModel`, and `ActivityModel`).
- **SharedPreferences (^2.5.5):** Simple persistent storage for user preferences and theme states.

#### 3.7 UI Utilities & Document Export
- **FL Chart (^1.2.0):** High-performance charting library for rendering budget distribution pie charts and category breakdowns.
- **pdf (^3.12.0) & printing (^5.14.3):** Generates structured, printable PDF documents directly on the device.
- **shimmer (^3.0.0) & flutter_animate (^4.5.2):** Polished loading skeleton states and micro-interactions.
- **flutter_dotenv (^6.0.1):** Secure environment configuration management for private API keys.

---

### 4. SYSTEM ARCHITECTURE AND WORKING

#### 4.1 System Architectural Design (Clean Architecture)
The project strictly implements Uncle Bob's Clean Architecture principles:
- **Presentation Layer:** Contains Flutter UI screens (Pages), reusable UI elements (Widgets), and BLoCs (`AuthBloc`, `TripBloc`, `ExpenseBloc`). UI views emit events to BLoCs and rebuild when new states are emitted.
- **Domain Layer:** Represents the core business rules. It contains pure Dart entities (`Trip`, `Expense`, `Weather`, `ItineraryDay`, `Activity`), repository interfaces, and use cases. This layer has zero dependencies on external libraries or Flutter UI.
- **Data Layer:** Implements repository interfaces defined in the domain layer. It contains Data Models (with JSON and Hive serialization logic) and Data Sources:
  - *Remote Data Sources:* `TripRemoteDataSourceImpl`, `GeoapifyRemoteDataSource`, `WikipediaRemoteDataSource`, `WeatherRemoteDataSource`.
  - *Local Data Sources:* `TripLocalDataSourceImpl`, `ExpenseLocalDataSourceImpl` powered by Hive.

#### 4.2 Step-by-Step Working Mechanism

```
[User Input: Destination, Dates, Budget, Interests]
                    │
                    ▼
[Presentation: CreateTripPage -> TripBloc]
                    │
                    ▼
[Data Layer: TripRepositoryImpl]
                    │
        ┌───────────┴───────────┐
        ▼                       ▼
[Geoapify API]          [Wikipedia API]
(Hotels & Restaurants)  (Local Attractions Extract)
        └───────────┬───────────┘
                    │ (Real-world context)
                    ▼
[Groq LLM: Llama-3.3-70b-versatile]
(Strict System Prompt + Real POIs -> JSON Output)
                    │
                    ▼
[JSON Parsing -> TripModel -> Hive Local DB Storage]
                    │
                    ▼
[Presentation: TripDetailsPage & BudgetDashboardPage]
(Leaflet Maps + Weather Forecast + FL Chart Expenses + PDF Export)
```

##### 4.2.1 User Authentication and Profile Setup
1. When launched, `SplashScreen` checks the current authentication status via `AuthBloc`.
2. First-time users are guided through `OnboardingScreen` followed by `LoginPage` or `RegisterPage`.
3. Users authenticate via Firebase Authentication (Email/Password or Google Sign-In). On success, their authentication token is cached, and the app transitions to `HomePage`.

##### 4.2.2 Trip Creation and User Preference Capture
1. In `CreateTripPage`, the user selects:
   - Target destination (with autocomplete suggestions).
   - Start and end travel dates.
   - Total trip budget in INR (₹).
   - Personal travel interests (e.g., Adventure, Heritage, Food, Nature, Relaxation).
2. The page dispatches a `GenerateTripEvent` to `TripBloc`.

##### 4.2.3 Retrieval-Augmented Generation (RAG) Pipeline
To prevent the LLM from inventing fake hotels or impossible attractions, a three-phase RAG pipeline executes in `TripRemoteDataSourceImpl`:
1. **Real Place Retrieval:** The app calls the Geoapify Places API to fetch verified hotels and dining establishments currently operating in the destination.
2. **Context Enrichment:** The app queries the Wikipedia REST API to extract official geographical and historical summaries for the destination, identifying legitimate monuments and cultural sites.
3. **Constrained Prompt Generation:** A structured prompt is assembled containing the traveler's constraints (budget, dates, interests) alongside the verified Geoapify POIs and Wikipedia text.
4. **Structured LLM Inference:** The prompt is sent to the Groq API running `llama-3.3-70b-versatile` under strict system instructions demanding pure JSON output conforming to the itinerary schema.
5. **Deserialization & Validation:** The returned JSON response is deserialized into `TripModel`, validated, and returned to `TripBloc`.

##### 4.2.4 Real-time Weather and Geospatial Mapping
1. Upon loading `TripDetailsPage`, parallel asynchronous calls are dispatched:
   - Coordinates are retrieved for the destination to center an interactive OpenStreetMap view using `flutter_map`.
   - Current weather conditions and temperature are fetched via `WeatherRemoteDataSource` using the OpenWeatherMap API and presented in an info card.

##### 4.2.5 Itinerary Display and Activity Tracking
1. The trip itinerary is organized day-by-day.
2. Each day displays chronologically sorted activities with specific timing, activity title, descriptive summary, physical location, and estimated cost.
3. An automated packing checklist generated based on trip duration and destination characteristics is also presented.

##### 4.2.6 Dynamic Expense Tracking & Budget Analytics
1. From `BudgetDashboardPage`, users track real-world expenditures during the journey.
2. Users log expenses by entering the title, amount, and selecting a category (e.g., Food, Transport, Accommodation, Activities, Shopping, Miscellaneous).
3. The `ExpenseBloc` computes:
   - Total money spent so far.
   - Remaining budget balance.
   - Budget consumption percentage with dynamic color indicators (Normal, Warning, Over-budget).
4. `FL Chart` renders a real-time pie chart displaying percentage expenditures across categories.

##### 4.2.7 Offline Persistence and PDF Export
1. Every generated itinerary and logged expense is immediately stored locally in Hive binary boxes (`trips` and `expenses`).
2. Even in airplane mode or remote areas with no cellular network, the user can open saved trips, view daily schedules, and log new expenses.
3. Through the `pdf` and `printing` packages, users can click "Export Itinerary" to generate a formatted A4 PDF containing the complete day-by-day itinerary, budget summary, and packing list for printing or offline sharing.

---

### 5. MODULES AND FUNCTIONAL REQUIREMENTS

| Module Name | Core Functionality | Primary Components / Files |
| :--- | :--- | :--- |
| **Authentication Module** | User signup, login, session checking, and sign out | `auth_bloc.dart`, `login_page.dart`, `register_page.dart` |
| **Trip Creation Module** | Form validation, date range picking, interest selection | `create_trip_page.dart`, `trip_bloc.dart` |
| **RAG AI Generation Module** | Retrieval from Geoapify & Wikipedia; Groq API inference | `trip_remote_data_source.dart`, `geoapify_remote_data_source.dart` |
| **Weather & Maps Module** | Live temperature and OpenStreetMap pin rendering | `weather_remote_data_source.dart`, `flutter_map` in `trip_details_page.dart` |
| **Expense & Budget Module**| Expense CRUD, category segregation, FL Chart analytics | `expense_bloc.dart`, `budget_dashboard_page.dart`, `expense_local_data_source.dart` |
| **Offline Storage Module** | Local binary serialization via Hive TypeAdapters | `trip_local_data_source.dart`, `hive_flutter` |
| **Document Export Module** | In-app generation of formatted multi-page PDF documents| `trip_details_page.dart` (`pw.Document`, `Printing.layoutPdf`) |

---

### 6. CONCLUSION AND FUTURE SCOPE

#### 6.1 Conclusion
The Smart AI Travel Planner application successfully demonstrates how modern mobile development and artificial intelligence can be combined to solve real-world logistical problems. By implementing Clean Architecture and BLoC state management in Flutter, the codebase remains scalable, modular, and easy to maintain. 

Crucially, the application resolves the common problem of AI hallucinations by employing a Retrieval-Augmented Generation (RAG) approach that grounds LLM prompts with verified real-world places from Geoapify and Wikipedia. Coupled with offline Hive storage, live weather updates, interactive maps, dynamic budget analytics, and one-click PDF generation, the application serves as a practical, comprehensive travel assistant.

#### 6.2 Key Challenges Faced & Solutions
1. **LLM Hallucinations:** Generic models frequently suggested fictional hotels and places outside the destination boundary.  
   *Solution:* Implemented pre-prompt retrieval using Geoapify and Wikipedia extracts, strictly instructing the model to reuse verified entities.
2. **Structured Output Reliability:** LLMs sometimes produce markdown-wrapped text or broken JSON.  
   *Solution:* Used Groq's native `json_object` response format with strict schema definitions in the prompt.
3. **Offline Usability:** Travelers often lose internet connectivity during journeys.  
   *Solution:* Integrated Hive NoSQL local boxes with custom TypeAdapters to cache all trip details, itinerary items, and expenses locally.

#### 6.3 Future Enhancements
- **Multi-Currency Support:** Automatic currency conversion and real-time exchange rates for international travelers.
- **Collaborative Group Trips:** Shared itineraries and split-expense calculation among multiple travelers using Cloud Firestore real-time listeners.
- **Flight and Train Booking API Integration:** Direct deep-linking to transportation reservation portals.
- **Turn-by-turn Navigation:** Offline GPS routing and turn-by-turn navigation between scheduled itinerary stops.
