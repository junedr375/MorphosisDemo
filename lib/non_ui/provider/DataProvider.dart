import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:morphosis_flutter_demo/non_ui/api/ApiConnection.dart';
import 'package:morphosis_flutter_demo/non_ui/modal/photo.dart';

enum HomeState {
  Initial,
  Loading,
  Loaded,
  Error,
}
enum HomeMoreLoadingStatus {
  NA,
  MoreLoading,
  MoreLoaded,
}
enum HomeSearchStatus {
  Empty,
  SearchNotFound,
  Searching,
  SearchedFound,
}

class DataNotifier extends ChangeNotifier {
  HomeState _homeState = HomeState.Initial;
  HomeMoreLoadingStatus _homeMoreLoadingStatus = HomeMoreLoadingStatus.NA;
  HomeSearchStatus _homeSearchStatus = HomeSearchStatus.Empty;
  List<Photo> photos = [];

  List<Photo> searchedPhotos = [];
  Box<Photo> photoBox;
  int pagedIndex = 1;

  DataNotifier() {
    _fetchPhotosFromApi();
    photoBox = Hive.box('photoBox');
  }
  HomeState get homeState => _homeState;
  HomeMoreLoadingStatus get homeMoreLoading => _homeMoreLoadingStatus;
  HomeSearchStatus get homeSearchStatus => _homeSearchStatus;

  Future<void> get fetchPhotoFromApi => _fetchPhotosFromApi();
  Future<void> get fetchMorePhotoFromApi => _fetchMorePhotosFromApi();
  Future<void> searchFromLocalDB(String query) => _searchFromLocalHiveDB(query);

  Future<void> _searchFromLocalHiveDB(String query) {
    try {
      if (query.length == 0) {
        _fetchPhotosFromApi();
        notifyListeners();
      } else {
        searchedPhotos.clear();

        _homeSearchStatus = HomeSearchStatus.Searching;
        notifyListeners();
        if (photoBox.length != 0) {
          for (int i = 0; i < photoBox.length; i++) {
            if (photoBox
                .getAt(i)
                .photographer
                .toLowerCase()
                .contains(query.toLowerCase())) {
              searchedPhotos.add(photoBox.getAt(i));
            }
          }

          if (searchedPhotos.isNotEmpty) {
            _homeSearchStatus = HomeSearchStatus.SearchedFound;
            notifyListeners();
          } else {
            _homeSearchStatus = HomeSearchStatus.SearchNotFound;
            notifyListeners();
          }
        } else {
          _homeSearchStatus = HomeSearchStatus.Empty;
        }
      }
    } catch (e) {
      _homeState = HomeState.Error;
    }
    notifyListeners();
  }

  Future<void> _fetchPhotosFromApi() async {
    _homeState = HomeState.Loading;
    notifyListeners();
    try {
      await Future.delayed(Duration(seconds: 2));
      final apiPhotos =
          await ApiConnection.apiInstance.getPhotosFromAPI(pagedIndex);
      photos = apiPhotos;
      await photoBox.clear();
      photoBox.addAll(photos);
      _homeState = HomeState.Loaded;
    } catch (e) {
      _homeState = HomeState.Error;
    }
    notifyListeners();
  }

  Future<void> _fetchMorePhotosFromApi() async {
    _homeMoreLoadingStatus = HomeMoreLoadingStatus.MoreLoading;
    notifyListeners();
    try {
      pagedIndex++;
      final apiPhotos =
          await ApiConnection.apiInstance.getPhotosFromAPI(pagedIndex);
      photos.addAll(apiPhotos);

      await photoBox.clear();
      Future.delayed(Duration(seconds: 1), () {
        photoBox.addAll(photos);
      });
      _homeMoreLoadingStatus = HomeMoreLoadingStatus.MoreLoaded;
    } catch (e) {
      _homeState = HomeState.Error;
    }
    notifyListeners();
  }

  Future clearPhotoBox() {
    photoBox.clear();
  }
}
