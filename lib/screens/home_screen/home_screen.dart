import 'package:countries_app/blocs/Country/country_bloc.dart';
import 'package:countries_app/models/country/country.dart';
import 'package:countries_app/repository/getCountry.dart';
import 'package:countries_app/screens/constants/styles.dart';
import 'package:countries_app/screens/constants/widgets/shake_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/country_tile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TextEditingController _textController = TextEditingController();
  AnimationController _animationController;
  Animation _animation1;
  Animation _animation2;
  int _searchValue = 1;
  bool isMulti = false;
  bool isComplete = false;
  String searchText = "";

  @override
  void initState() {
    BlocProvider.of<CountryBloc>(context).add(CountryGetEvent());

    super.initState();
  }

  onSearch(String value) {}

  bool willShow = false;

  void showSearch(Size size) {
    !willShow
        ? setState(() {
            willShow = !willShow;
            _animationController = AnimationController(
                vsync: this, duration: Duration(seconds: 1));
            _animation1 = Tween<double>(
              begin: 0,
              end: size.width * 0.8,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.linearToEaseOut,
              ),
            );
            _animation2 = Tween<double>(
              begin: 0,
              end: size.height * 0.4,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.linearToEaseOut,
              ),
            );
            _animationController.forward().whenComplete(() {
              setState(() {
                isComplete = true;
              });
            });
          })
        : _animationController.reverse().whenComplete(() {
            setState(() {
              willShow = !willShow;
            });
          });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (willShow) {
          showSearch(size);
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Countries"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                icon: Icon(Icons.search_outlined),
                onPressed: () {
                  showSearch(size);
                })
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<CountryBloc, CountryState>(
            builder: (context, state) {
              if (state is CountryLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is CountrySuccess) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: RefreshIndicator(
                            // ignore: missing_return
                            onRefresh: () {
                              BlocProvider.of<CountryBloc>(context)
                                  .add(CountryGetEvent());
                            },
                            child: state.countries.length > 0
                                ? ListView.separated(
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) =>
                                        Divider(height: 5, color: Colors.black),
                                    itemCount: state.countries.length,
                                    itemBuilder: (context, index) {
                                      Country country = state.countries[index];
                                      return ShakeTransition(
                                          offset: 50,
                                          child: CountryTile(country: country));
                                    },
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Sorry. Can't find that country."),
                                        IconButton(
                                            icon: Icon(Icons.replay),
                                            onPressed: () {
                                              BlocProvider.of<CountryBloc>(
                                                      context)
                                                  .add(CountryGetEvent());
                                            })
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    willShow
                        ? Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showSearch(size);
                                },
                                child: Container(
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ),
                              Center(
                                child: AnimatedBuilder(
                                  animation: _animationController,
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                      ),
                                      width: _animation1.value,
                                      height: _animation2.value,
                                      child: _animation1.value > 290.0 &&
                                              _animation2.value > 250.0
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  TextField(
                                                    controller: _textController,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 5.0,
                                                              horizontal: 10.0),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 1.0),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 1.0),
                                                      ),
                                                      border:
                                                          UnderlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0)),
                                                      hintText:
                                                          'Search Country...',
                                                    ),
                                                    onChanged: (value) {
                                                      searchText = value;
                                                    },
                                                  ),
                                                  SizedBox(height: 30),
                                                  Row(
                                                    children: [
                                                      Text("Type: ",
                                                          style: text.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10.0,
                                                                right: 10.0),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: DropdownButton(
                                                            value: _searchValue,
                                                            items: [
                                                              DropdownMenuItem(
                                                                child: Text(
                                                                    "Search all",
                                                                    style: text.copyWith(
                                                                        color: Colors
                                                                            .black)),
                                                                value: 1,
                                                              ),
                                                              DropdownMenuItem(
                                                                child: Text(
                                                                    "Search by name",
                                                                    style: text.copyWith(
                                                                        color: Colors
                                                                            .black)),
                                                                value: 2,
                                                              ),
                                                              DropdownMenuItem(
                                                                child: Text(
                                                                    "Search by code",
                                                                    style: text.copyWith(
                                                                        color: Colors
                                                                            .black)),
                                                                value: 3,
                                                              ),
                                                            ],
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _searchValue =
                                                                    value;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  _searchValue == 3
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Checkbox(
                                                              value: isMulti,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  isMulti =
                                                                      value;
                                                                });
                                                              },
                                                            ),
                                                            Center(
                                                                child: Text(
                                                                    "is multi-code?"))
                                                          ],
                                                        )
                                                      : SizedBox(),
                                                  _searchValue == 3 && isMulti
                                                      ? Text(
                                                          'Use ";" to separate codes',
                                                          style: text.copyWith(
                                                              color:
                                                                  Colors.grey),
                                                        )
                                                      : SizedBox.shrink(),
                                                  Spacer(),
                                                  Container(
                                                    height: 50,
                                                    width: double.infinity,
                                                    child: ElevatedButton.icon(
                                                      onPressed: () {
                                                        //hides the search form
                                                        showSearch(size);

                                                        //initialize need variables
                                                        SearchType searchType;

                                                        if (_searchValue == 2) {
                                                          searchType =
                                                              SearchType
                                                                  .searchByName;
                                                        } else if (_searchValue ==
                                                            3) {
                                                          searchType =
                                                              SearchType
                                                                  .searchByCode;
                                                        } else {
                                                          searchType =
                                                              SearchType
                                                                  .searchAll;
                                                        }

                                                        //execute the event of getCountry
                                                        BlocProvider.of<
                                                                    CountryBloc>(
                                                                context)
                                                            .add(CountryGetEvent(
                                                                searchType:
                                                                    searchType,
                                                                isMulti:
                                                                    isMulti,
                                                                searchText:
                                                                    searchText));

                                                        //clear all search
                                                        setState(() {
                                                          isMulti = false;
                                                          _searchValue = 1;
                                                          searchText = "";
                                                          _textController
                                                              .clear();
                                                        });
                                                      },
                                                      icon: Icon(Icons
                                                          .search_outlined),
                                                      label: Text("Search"),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : SizedBox(),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
