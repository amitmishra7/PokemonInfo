

class AppConstants{
  static int connectionTimeout = 30000;
  static int receiveTimeout = 3000;

  static String baseUrl = "";
  static String pokemonImageBaseURL = "https://maurowernly.github.io/Pokedex/images/";

  static String getPokemonImageUrl(String id, String name) {
    var imageUrl = AppConstants.pokemonImageBaseURL +
        "pokemons/" +
        getThreeDigitId(id) +
        name +
        ".png";
    print(imageUrl);
    return imageUrl;
  }

  static String getPokemonTypeImageUrl(String type) {
    var imageUrl = AppConstants.pokemonImageBaseURL + "types/" + type + ".png";
    print(imageUrl);
    return imageUrl;
  }

  static String getThreeDigitId(String id) {
    if (id.length == 1) {
      return "00$id";
    } else if (id.length == 2) {
      return "0$id";
    } else {
      return id;
    }
  }

}