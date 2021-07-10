import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morphosis_flutter_demo/non_ui/modal/photo.dart';
import 'package:provider/provider.dart';
import 'package:morphosis_flutter_demo/non_ui/provider/DataProvider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TextEditingController _searchTextField = TextEditingController();

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    //   _searchTextField.text = "Search From Local DB";
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<DataNotifier>(context, listen: false).fetchMorePhotoFromApi;
        // When scrolling to end it will fetch more Photos
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _searchTextField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [],
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /* In this section we will be testing your skills with network and local storage. You need to fetch data from any open source api from the internet. 
             E.g: 
             https://any-api.com/
             https://rapidapi.com/collection/best-free-apis?utm_source=google&utm_medium=cpc&utm_campaign=Beta&utm_term=%2Bopen%20%2Bsource%20%2Bapi_b&gclid=Cj0KCQjw16KFBhCgARIsALB0g8IIV107-blDgIs0eJtYF48dAgHs1T6DzPsxoRmUHZ4yrn-kcAhQsX8aAit1EALw_wcB
             Implement setup for network. You are free to use package such as Dio, Choppper or Http can ve used as well.
             Upon fetching the data try to store thmm locally. You can use any local storeage. 
             Upon Search the data should be filtered locally and should update the UI.
            */

            /* Data Fetched from https://api.pexels.com/v1/ API implemetion in ApiConnection.dart page  */
            CupertinoSearchTextField(
              controller: _searchTextField,
              onChanged: (val) {
                setState(() {});
                Provider.of<DataNotifier>(context, listen: false)
                    .searchFromLocalDB(val);
              },
              onSuffixTap: () {
                setState(() {
                  _searchTextField.text = '';
                });
              },
            ),
            SizedBox(height: 10),
            Visibility(
              visible: _searchTextField.text.length != 0,
              child: Expanded(
                child: _searchTileWidget(),
              ),
            ),
            Visibility(
              visible: _searchTextField.text.length == 0,
              child: Expanded(
                child: _listTileWidget(),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  //Search is implememted on DB
  Widget _searchTileWidget() {
    return Consumer<DataNotifier>(builder: (ctx, photProvider, child) {
      if (photProvider.homeSearchStatus == HomeSearchStatus.Searching) {
        return Center(child: CircularProgressIndicator());
      }
      if (photProvider.homeState == HomeState.Error) {
        return Center(child: Text('An Error Occured '));
      }
      if (photProvider.homeSearchStatus == HomeSearchStatus.SearchNotFound) {
        return Center(child: Text('No Result Found '));
      }
      if (photProvider.homeSearchStatus == HomeSearchStatus.Empty) {
        return Center(child: Text('Local DB is Empty '));
      }

      if (photProvider.homeSearchStatus == HomeSearchStatus.SearchedFound) {
        return Column(
          children: [
            Container(
              height: 30,
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Center(
                child: Text('Fetching data from Local DB'),
              ),
            ),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int indexChild) {
                    Photo photo = photProvider.searchedPhotos[indexChild];
                    return Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Image.network(
                              photo.src.landscape,
                              fit: BoxFit.fill,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                    child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ));
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                photo.photographer,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder:
                      (BuildContext context, int separeatorChild) {
                    return SizedBox(height: 10);
                  },
                  itemCount: photProvider.searchedPhotos.length),
            ),
          ],
        );
      } else {
        return Container();
      }
    });
  }

  Widget _listTileWidget() {
    return Consumer<DataNotifier>(builder: (ctx, photProvider, child) {
      if (photProvider.homeState == HomeState.Loading) {
        return Center(child: CircularProgressIndicator());
      }
      if (photProvider.homeState == HomeState.Error) {
        return Center(child: Text('An Error Occured '));
      }
      if (photProvider.homeState == HomeState.Loaded) {
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int indexChild) {
                    Photo photo = photProvider.photos[indexChild];
                    return Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Image.network(
                              photo.src.landscape,
                              fit: BoxFit.fill,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                    child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ));
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                photo.photographer,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder:
                      (BuildContext context, int separeatorChild) {
                    return SizedBox(height: 10);
                  },
                  itemCount: photProvider.photos.length),
            ),
            Visibility(
                visible: photProvider.homeMoreLoading ==
                    HomeMoreLoadingStatus.MoreLoading,
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: CircularProgressIndicator(),
                ))
          ],
        );
      } else {
        return Container();
      }
    });
  }
}
