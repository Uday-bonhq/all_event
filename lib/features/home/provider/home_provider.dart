import 'dart:convert';
import 'package:all_event/features/home/model/category_event_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class EventState {
  final List<CategoryModel> categories;
  final String selectedCategory;
  final Map<String, List<EventData>> eventsByCategory;
  final List<EventData> eventList;
  final List<EventData> randomEventList;
  final bool isLoading;
  final String? error;
  final bool showAsList;
  final RangeValues range;
  final String searchQuery;
  final String userLocation;

  EventState({
    this.categories = const [],
    this.eventList = const [],
    this.randomEventList = const [],
    this.eventsByCategory = const {},
    this.isLoading = true,
    this.selectedCategory = "",
    this.showAsList = true,
    this.error,
    this.searchQuery = "",
    this.userLocation = "Ahmedabad",
    this.range = const RangeValues(100, 1500),
  });

  EventState copyWith({
    List<CategoryModel>? categories,
    List<EventData>? eventList,
    List<EventData>? randomEventList,
    Map<String, List<EventData>>? eventsByCategory,
    bool? isLoading,
    bool? showAsList,
    String? error,
    String? selectedCategory,
    String? searchQuery,
    String? userLocation,
    RangeValues? range,
  }) {
    return EventState(
      categories: categories ?? this.categories,
      eventList: eventList ?? this.eventList,
      randomEventList: randomEventList ?? this.randomEventList,
      eventsByCategory: eventsByCategory ?? this.eventsByCategory,
      isLoading: isLoading ?? this.isLoading,
      showAsList: showAsList ?? this.showAsList,
      error: error ?? this.error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      userLocation: userLocation ?? this.userLocation,
      range: range ?? this.range,
    );
  }
}


// StateNotifier to manage EventState
class EventStateNotifier extends StateNotifier<EventState> {
  EventStateNotifier() : super(EventState()) {
    fetchCategories();
    getNetworkLocation();
  }

  Future<void> fetchCategories() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      const url = 'https://allevents.s3.amazonaws.com/tests/categories.json';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final categories = data.map((e) => CategoryModel.fromJson(e)).toList();
        state = state.copyWith(
          categories: categories,
        );
        print("updatedEvents.length ${categories.length}");

        state = state.copyWith(isLoading: true);

        for (var category in categories) {

          await fetchEventsForCategory(category);
          if(category.category == "all"){
            await filteredEventsList();
          }
        }

        state = state.copyWith(
          isLoading: false,
        );

      } else {
        state = state.copyWith(
          error: 'Failed to load categories',
          isLoading: false,
        );
      }
    } catch (e) {
      print("Error: $e");
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> fetchEventsForCategory(CategoryModel category) async {
    // try {
      final response = await http.get(Uri.parse(category.data));

      if (response.statusCode == 200) {
        print("Fetched data for category ${category.category}");

        final decodedJson = jsonDecode(response.body);

        final List<dynamic> data = decodedJson["item"] ?? [];

        final events = data.map<EventData>((e) => EventData.fromJson(e)).toList();

        final updatedEvents = {...state.eventsByCategory};
        updatedEvents[category.category] = events;


        state = state.copyWith(
          eventsByCategory: updatedEvents,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load events for ${category.category}',
        );
      }
    // } catch (e) {
    //   print("Error fetching events: $e");
    //   state = state.copyWith(
    //     isLoading: false,
    //     error: e.toString(),
    //   );
    // }
  }

  updateSelectedCategory({selectedCategory}){
    print(selectedCategory);
    state = state.copyWith(
      selectedCategory: selectedCategory,
    );
    print(state.selectedCategory);
  }
  updateShowAsList({required bool value}){
    state = state.copyWith(
      showAsList: value,
    );
    print(state.selectedCategory);
  }




  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);

    filteredEventsList();
  }

  Future filteredEventsList() async{
    final category = state.selectedCategory.isEmpty ? "all" : state.selectedCategory;
    final allEvents = state.eventsByCategory[category] ?? [];
    final query = state.searchQuery.toLowerCase();


    var list =  allEvents.where((event) {
      return (event.eventname ?? '').toLowerCase().contains(query);
    }).toList();
    state = state.copyWith(
      eventList: list,
    );

  }

  List<EventData> get filteredEvents {
    final category = state.selectedCategory.isEmpty ? "all" : state.selectedCategory;
    final allEvents = state.eventsByCategory[category] ?? [];
    final query = state.searchQuery.toLowerCase();

    if (query.isEmpty) return allEvents;

    return allEvents.where((event) {
      return (event.eventname ?? '').toLowerCase().contains(query);
    }).toList();
  }

   randomEvents(id) {
    final allEvents = state.eventsByCategory.values.expand((e) => e).toList();

    allEvents.removeWhere((item)=> item.eventId == id);
    allEvents.shuffle();

    state = state.copyWith(
      randomEventList: allEvents.take(10).toList(),
    );
  }




  /// Gets approximate location based on network IP (no permissions required).
  Future<String?> getNetworkLocation() async {
    try {
      final response = await http.get(Uri.parse('https://ipinfo.io/json'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final city = data['city'] ?? 'Unknown city';
        final region = data['region'] ?? '';
        final country = data['country'] ?? '';

        state = state.copyWith(
            userLocation: city ?? region ?? state.userLocation,
        );
        return '$city, $region, $country';
      } else {
        return 'Failed to fetch location';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }


}

// Providers
final eventStateProvider = StateNotifierProvider<EventStateNotifier, EventState>(
      (ref) => EventStateNotifier(),
);

// Models
class CategoryModel {
  final String category;
  final String data;

  CategoryModel({required this.category, required this.data});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      category: json['category'] as String,
      data: json['data'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'category': category,
    'data': data,
  };
}

