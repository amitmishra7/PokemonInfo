class ErrorModel {
  String code;
  String message;

  // todo check code everywhere for int and string
  ErrorModel({this.code, this.message});

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      code: json['code'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code.toString();
    data['message'] = this.message;
    return data;
  }
}
