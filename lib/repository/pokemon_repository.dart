import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pokemon_info/api/api_request.dart';
import 'package:pokemon_info/repository/base_repo/base_repo.dart';

///Repository class responsible for handling pokemon rest calls.
class PokemonRepository extends BaseRepo {
  ApiRequest apiRequest = ApiRequest();

  ///Get pokemon list
  Future<Response> getPokemonList() async {

    try {
      Response response = await apiRequest.get(
          endPoint: "https://maurowernly.github.io/Pokedex/data/pokedex.json");
      print("Dio response-- ${response.data}");
      return Future.value(response);
    } catch (err) {
      return Future.error(err.toString());
    }
  }

  ///Get todo list
  Future<Response> getToDoList() async {

    try {
      Response response = await apiRequest.get(
          endPoint: "https://jsonplaceholder.typicode.com/todos");
      //print("Dio response-- ${response.data}");

      return Future.value(response);
    } catch (err) {
      return Future.error(err.toString());
    }
  }
}
