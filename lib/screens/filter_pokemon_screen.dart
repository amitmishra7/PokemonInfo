import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon_info/util/strings.dart';

class PokemonFilterScreen extends StatefulWidget {
  final Set<String> filterOptions;
  final Set<String> filteredOptions;

  PokemonFilterScreen({this.filterOptions,this.filteredOptions});

  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonFilterScreen> {
  List<FilterOption> filterOptions = [];
  Set<String> selectedOptions;

  @override
  void initState() {
    setState(() {
      selectedOptions = widget.filteredOptions!=null?widget.filteredOptions:Set();
      widget.filterOptions.forEach((value) {
        filterOptions.add(FilterOption(value, widget.filteredOptions!=null?widget.filteredOptions.contains(value):false));
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: _buildFilterUI(),
      ),
    );
  }

  /// build app bar
  _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.pinkAccent,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context,Set());
        },
        child: Icon(Icons.arrow_back_ios),
      ),
      title: Text(
        Strings.filter,
        style: GoogleFonts.nunitoSans(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// filter UI
  _buildFilterUI() {
    return Row(
      children: [
        _buildFilterCategories(),
        _buildFilterOptions(),
      ],
    );
  }

  /// filter categories
  _buildFilterCategories() {
    return Expanded(
      flex: 1,
      child: Container(
        color: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(
                    'Type',
                    style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    filterOptions.forEach((type) {
                      type.value = false;
                    });
                  });
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  width: MediaQuery.of(context).size.width - 40,
                  child: Center(
                      child: Text(
                    'Clear',
                    style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// filter options
  _buildFilterOptions() {
    return Expanded(
      flex: 2,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(child: _buildPokemonList()),
              InkWell(
                onTap: () {
                  Navigator.pop(context,selectedOptions);
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  width: MediaQuery.of(context).size.width - 40,
                  child: Center(
                      child: Text(
                    'Filter',
                    style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  )),
                ),
              ),
            ],
          )),
    );
  }

  /// Pokemon list
  _buildPokemonList() {
    return ListView.builder(
      itemCount: filterOptions.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, index) {
        return _buildFilterItem(filterOptions.elementAt(index));
      },
    );
  }

  /// Individual pokemon item
  Widget _buildFilterItem(FilterOption filterOption) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: Text(
              filterOption.name,
              style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
            ),
            leading: Checkbox(
              value: filterOption.value,
              onChanged: (value) {
                if (value) {
                  selectedOptions.add(filterOption.name);
                } else {
                  selectedOptions.remove(filterOption.name);
                }
                setState(() {
                  filterOption.value = value;
                });
              },
              activeColor: Colors.pinkAccent,
            ),
          ),
        ),
      ],
    );
  }
}

class FilterOption {
  String name;
  bool value;

  FilterOption(this.name, this.value);
}
