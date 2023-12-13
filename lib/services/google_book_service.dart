import 'dart:convert';

import 'package:http/http.dart' as http;

class GoogleBooksService {
  static const String baseUrl = "https://www.googleapis.com/books/v1/volumes";

  Future<List<GoogleBook>> searchBooks(String name) async {
    if(name != "") {
      http.Response httpResponse = await http.get(Uri.parse("$baseUrl/?q=$name"));

      Map<String, dynamic> response = json.decode(httpResponse.body);
      List listResponse = response["items"];

      List<GoogleBook> listResult = [];
      for (int i = 0; i < listResponse.length; i++) {
        listResult.add(GoogleBook.fromApi(listResponse[i]));
      }

      return listResult;
    }
    return List.empty();
  }
}

class GoogleBook {
  late String id;
  late String title;
  late String authors;
  late String description;
  late String thumbnailLink;

  GoogleBook({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.thumbnailLink,
  });

  GoogleBook.fromApi(Map<String, dynamic> map) {
    id = map["id"];
    title = validateTitle(map);
    authors = validateAuthor(map);
    description = validateDescription(map);
    thumbnailLink = validateThumbnail(map);
  }

  validateTitle(Map<String, dynamic> map) => map["volumeInfo"]["title"] ?? "Título não identificado";
  
  validateAuthor(Map<String, dynamic> map) => (map["volumeInfo"]["authors"] as List<dynamic>).map((e) => e).toString() == null ? "Autor não identificado" : map["volumeInfo"]["authors"];

  validateDescription(Map<String, dynamic> map) => map["volumeInfo"]["description"] ?? "Sem Descrição";

  validateThumbnail(Map<String, dynamic> map) => map["volumeInfo"]["imageLinks"]?["thumbnail"] ?? "https://placehold.co/300x200?text=Image+not+found";

  GoogleBook.fromJson(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    authors = map["authors"];
    description = map["description"];
    thumbnailLink = map["thumbnailLink"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "authors": authors,
      "description": description,
      "thumbnailLink": thumbnailLink,
    };
  }
}
