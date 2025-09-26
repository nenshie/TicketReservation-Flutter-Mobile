class LoginResponseDto{
  final String jwtToken;

  LoginResponseDto({required this.jwtToken});

  factory LoginResponseDto.fromJson(Map<String, dynamic> json){
    return LoginResponseDto(
      jwtToken: json['jwtToken'],
    );
  }

}