import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon_info/models/PokemonModel.dart';
import 'package:pokemon_info/util/app_constants.dart';

class PokemonDetailsScreen extends StatefulWidget {
  Color backgroundColor;
  PokemonModel pokemonDetails;

  PokemonDetailsScreen({this.backgroundColor, this.pokemonDetails});

  @override
  _PokemonDetailsState createState() => _PokemonDetailsState();
}

class _PokemonDetailsState extends State<PokemonDetailsScreen> {
  @override
  void initState() {
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: widget.backgroundColor,
          body: OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _buildPokemonId(orientation),
                        _buildPokemonName(),
                        _buildPokemonImage(orientation),
                        _buildPokemonDivider(),
                        _buildPokemonType(orientation),
                        _buildBaseStatsTitle(),
                        _buildBaseStats(orientation)
                      ],
                    ),
                  ),
                );
              } else {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPokemonId(orientation),
                              _buildPokemonName(),
                              _buildPokemonImage(orientation),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPokemonType(orientation),
                              _buildBaseStatsTitle(),
                              _buildBaseStats(orientation),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            },
          )),
    );
  }

  /// pokemon divider
  _buildPokemonDivider() {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.5,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.white38,
          border: Border.all(color: Colors.white38, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }

  /// pokemon Id
  _buildPokemonId(Orientation orientation) {
    return Padding(
      padding: EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          Text(
            '#${AppConstants.getThreeDigitId(widget.pokemonDetails.id.toString())}',
            style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          Visibility(
            visible: orientation == Orientation.portrait,
            child: Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.landscapeRight]);
                  },
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      Icons.screen_rotation,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            )),
          )
        ],
      ),
    );
  }

  /// pokemon Name
  _buildPokemonName() {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            widget.pokemonDetails.name.english,
            style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// base stats title
  _buildBaseStatsTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 10),
      child: Text("Base Stats",
          style: GoogleFonts.nunitoSans(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.white,
            ),
          )),
    );
  }

  /// base stats
  _buildBaseStats(Orientation orientation) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Visibility(
            visible: orientation == Orientation.landscape,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
              child: Container(
                width: 5,
                color: Colors.white38,
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                _buildStats('HP : ${widget.pokemonDetails.base.hP}'),
                _buildStats('ATTACK : ${widget.pokemonDetails.base.attack}'),
                _buildStats('DEFENCE : ${widget.pokemonDetails.base.defense}'),
                _buildStats(
                    'SP. ATTACK : ${widget.pokemonDetails.base.spAttack}'),
                _buildStats(
                    'SP. DEFENCE : ${widget.pokemonDetails.base.spDefense}'),
                _buildStats('SPEED : ${widget.pokemonDetails.base.speed}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// pokemon stats
  _buildStats(String value) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
          child: Text(value,
              style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.black,
                ),
              )),
        ),
      ),
    );
  }

  /// pokemon Image
  _buildPokemonImage(Orientation orientation) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CachedNetworkImage(
              width: orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width * 2 / 3
                  : MediaQuery.of(context).size.height * 1.8 / 3,
              height: orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width * 2 / 3
                  : MediaQuery.of(context).size.height * 1.8 / 3,
              imageUrl: AppConstants.getPokemonImageUrl(
                  widget.pokemonDetails.id.toString(),
                  widget.pokemonDetails.name.english),
            ),
          ),
        ],
      ),
    );
  }

  /// pokemon type
  _buildPokemonType(Orientation orientation) {
    return Row(
      mainAxisAlignment: orientation == Orientation.portrait
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        Container(
          height: 60,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 20,
              );
            },
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: widget.pokemonDetails.type.length,
            itemBuilder: (context, index) {
              return CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Image.network(
                      AppConstants.getPokemonTypeImageUrl(
                          widget.pokemonDetails.type.elementAt(index)),
                    ),
                  ));
            },
          ),
        ),
        Visibility(
          visible: orientation == Orientation.landscape,
          child: Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                  onTap: () {
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.portraitUp]);
                  },
                  child: Icon(
                    Icons.screen_rotation,
                    color: Colors.white,
                    size: 30,
                  )),
            ],
          )),
        )
      ],
    );
  }
}
