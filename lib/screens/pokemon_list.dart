import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:pokemon_info/components/CustomBottomSheet.dart';
import 'package:pokemon_info/models/PokemonModel.dart';
import 'package:pokemon_info/repository/pokemon_repository.dart';
import 'package:pokemon_info/screens/filter_pokemon_screen.dart';
import 'package:pokemon_info/screens/pokemon_details.dart';
import 'package:pokemon_info/util/app_constants.dart';
import 'package:pokemon_info/util/strings.dart';

class PokemonListScreen extends StatefulWidget {
  PokemonListScreen({Key key}) : super(key: key);

  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonListScreen> {
  List<PokemonModel> searchedPokemonList = [];
  List<PokemonModel> totalPokemonList = [];
  List<PokemonModel> realPokemonList = [];
  PokemonRepository repository = PokemonRepository();
  bool isSearchEnabled = false;
  Sort _sortBy = Sort.Ascending;
  Set<String> filterOptions = Set();
  Set<String> filteredOptions = Set();
  Sort previousSort = Sort.Ascending;
  Comparator<PokemonModel> alphabeticalComparator =
      (a, b) => a.name.english.compareTo(b.name.english);
  Comparator<PokemonModel> ascendingComparator = (a, b) => a.id - b.id;
  Comparator<PokemonModel> descendingComparator = (a, b) => b.id - a.id;

  @override
  void initState() {
    super.initState();
    getPokemonList();
  }

  /// fetch pokemon list
  getPokemonList() async {
    Response response = await repository.getPokemonList();
    List<PokemonModel> list = response.data
        .map<PokemonModel>((json) => PokemonModel.fromJson(json))
        .toList();

    list.forEach((pokemonItem) {
      pokemonItem.type.forEach((pokemonType) {
        filterOptions.add(pokemonType);
      });
    });

    setState(() {
      searchedPokemonList.addAll(list);
      totalPokemonList.addAll(list);
      realPokemonList.addAll(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          title: Text(
            Strings.appName,
            style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            _buildPokemonToolBar(),
            _buildSearchField(),
            Expanded(
              child: _buildPokemonList(),
            ),
          ],
        ),
      ),
    );
  }

  /// search input field
  _buildSearchField() {
    return Visibility(
      visible: isSearchEnabled,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                onChanged: (value) => _onSearch(value),
                style: TextStyle(fontSize: 18),
                maxLines: 1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Pokemon Name',
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isSearchEnabled = false;
                  _onSearch('');
                });
              },
              child: Icon(
                Icons.cancel,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// search chars
  _onSearch(String chars) {
    searchedPokemonList.clear();
    if (chars.isEmpty) {
      setState(() {
        searchedPokemonList.addAll(totalPokemonList);
      });
    } else {
      setState(() {
        totalPokemonList.forEach((pokemonItem) {
          if (pokemonItem.name.english
              .toLowerCase()
              .contains(chars.toLowerCase())) {
            searchedPokemonList.add(pokemonItem);
          }
        });
      });
    }
  }

  /// Pokemon list
  _buildPokemonList() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Container(
              width: double.infinity, height: 1, color: Colors.grey);
        },
        itemCount: searchedPokemonList != null ? searchedPokemonList.length : 0,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          return _buildPokemonItem(searchedPokemonList.elementAt(index));
        },
      ),
    );
  }

  /// Individual pokemon item
  Widget _buildPokemonItem(PokemonModel item) {
    return FutureBuilder<Color>(
      future: getImagePalette(CachedNetworkImageProvider(
        AppConstants.getPokemonImageUrl(item.id.toString(), item.name.english),
      )),
      builder: (context, snapshot) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PokemonDetailsScreen(
                    backgroundColor: snapshot.data,
                    pokemonDetails: item,
                  ),
                ));
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _buildPokemonImage(item),
                _buildPokemonNameAndId(item),
                _buildPokemonType(item),
              ],
            ),
          ),
        );
      },
    );
  }

  /// pokemon id and name
  _buildPokemonNameAndId(PokemonModel item) {
    return Expanded(
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
              child: Text(
                '#${AppConstants.getThreeDigitId(item.id.toString())}',
                style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
              child: Text(
                item.name.english,
                style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// pokemon image
  _buildPokemonImage(PokemonModel item) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: CachedNetworkImage(
        width: 75,
        height: 75,
        imageUrl: AppConstants.getPokemonImageUrl(
            item.id.toString(), item.name.english),
      ),
    );
  }

  /// toolbar search sort filter
  _buildPokemonToolBar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isSearchEnabled = true;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Search',
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.search),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.grey,
              width: 1,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  _showBottomSheetSort(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sort',
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.sort),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.grey,
              width: 1,
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PokemonFilterScreen(
                          filterOptions: filterOptions,
                          filteredOptions: filteredOptions,
                        ),
                      ));
                  if (result != null && result.length > 0) {
                    filteredOptions = result;
                    filterList(result);
                  } else if (filteredOptions != null &&
                      filteredOptions.length > 0) {
                    filterList(filteredOptions);
                  } else {
                    filteredOptions.clear();
                    _sortList(true);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Filter',
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.filter_list),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// pokemon type
  _buildPokemonType(PokemonModel item) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        height: 40,
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 10,
            );
          },
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: item.type.length,
          itemBuilder: (context, index) {
            return Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Image.network(
                    AppConstants.getPokemonTypeImageUrl(
                        item.type.elementAt(index)),
                  ),
                ));
          },
        ),
      ),
    );
  }

  /// for pokemon color extraction
  Future<Color> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor.color;
  }

  /// sort bottom sheet
  void _showBottomSheetSort(BuildContext context) {
    showCustomModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              Container(
                height: 375,
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(5),
                      topRight: const Radius.circular(5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 6,
                        offset: Offset(0, 0),
                      ),
                    ]),
                child: _buildSortWidget(),
              ),
            ],
          );
        });
  }

  /// sort container
  _buildSortWidget() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                  child: Text(
                    'SORT BY',
                    style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Container(
                height: 1,
                color: Colors.grey,
              ),
            ),
            ListTile(
              title: Text(
                'Ascending',
                style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ),
              trailing: Radio<Sort>(
                value: Sort.Ascending,
                groupValue: _sortBy,
                activeColor: Colors.pinkAccent,
                onChanged: (Sort value) {
                  setState(() {
                    _sortBy = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(
                'Descending',
                style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ),
              trailing: Radio<Sort>(
                value: Sort.Descending,
                activeColor: Colors.pinkAccent,
                groupValue: _sortBy,
                onChanged: (Sort value) {
                  setState(() {
                    _sortBy = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(
                'Alphabetically',
                style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ),
              trailing: Radio<Sort>(
                value: Sort.Alphabetically,
                activeColor: Colors.pinkAccent,
                groupValue: _sortBy,
                onChanged: (Sort value) {
                  setState(() {
                    _sortBy = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(
                'Shuffle',
                style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ),
              trailing: Radio<Sort>(
                value: Sort.Shuffle,
                activeColor: Colors.pinkAccent,
                groupValue: _sortBy,
                onChanged: (Sort value) {
                  setState(() {
                    _sortBy = value;
                  });
                },
              ),
            ),
            InkWell(
              onTap: () {
                _sortList(false);
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                width: MediaQuery.of(context).size.width - 40,
                child: Center(
                    child: Text(
                  'SORT',
                  style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                )),
              ),
            )
          ],
        );
      },
    );
  }

  /// sort list
  _sortList(bool clearFilters) {
    if (clearFilters) {
      totalPokemonList.clear();
      searchedPokemonList.clear();
      totalPokemonList.addAll(realPokemonList);
      searchedPokemonList.addAll(realPokemonList);
    }
    if (_sortBy == Sort.Ascending) {
      setState(() {
        if (previousSort != Sort.Ascending) {
          totalPokemonList.sort(ascendingComparator);
          searchedPokemonList.sort(ascendingComparator);
        }
        previousSort = Sort.Ascending;
      });
    } else if (_sortBy == Sort.Descending) {
      setState(() {
        if (previousSort != Sort.Descending) {
          totalPokemonList.sort(descendingComparator);
          searchedPokemonList.sort(descendingComparator);
        }
        previousSort = Sort.Descending;
      });
    } else if (_sortBy == Sort.Shuffle) {
      setState(() {
        totalPokemonList.shuffle(Random());
        searchedPokemonList.clear();
        searchedPokemonList.addAll(totalPokemonList);
      });
      previousSort = Sort.Shuffle;
    } else if (_sortBy == Sort.Alphabetically) {
      setState(() {
        totalPokemonList.sort(alphabeticalComparator);
        searchedPokemonList.sort(alphabeticalComparator);
      });
      previousSort = Sort.Alphabetically;
    }
  }

  /// filter list
  filterList(Set<String> filteredValues) {
    searchedPokemonList.clear();
    searchedPokemonList = totalPokemonList.where((pokemonItem) {
      var isPresent = false;
      pokemonItem.type.forEach((pokemonType) {
        if (filteredValues.contains(pokemonType)) {
          isPresent = true;
        }
      });
      return isPresent;
    }).toList();
    totalPokemonList.clear();
    totalPokemonList.addAll(searchedPokemonList);
    _sortList(false);
  }
}

enum Sort { Ascending, Descending, Alphabetically, Shuffle }
