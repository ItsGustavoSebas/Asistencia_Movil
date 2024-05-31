import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    int statusCode;
    String message;
    OurUsers ourUsers;

    User({
        required this.statusCode,
        required this.message,
        required this.ourUsers,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        statusCode: json["statusCode"],
        message: json["message"],
        ourUsers: OurUsers.fromJson(json["ourUsers"]),
    );

    Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "ourUsers": ourUsers.toJson(),
    };
}

class OurUsers {
    int id;
    String email;
    String name;
    String password;
    dynamic city;
    String role;
    bool enabled;
    String username;
    List<Authority> authorities;
    bool accountNonLocked;
    bool accountNonExpired;
    bool credentialsNonExpired;

    OurUsers({
        required this.id,
        required this.email,
        required this.name,
        required this.password,
        required this.city,
        required this.role,
        required this.enabled,
        required this.username,
        required this.authorities,
        required this.accountNonLocked,
        required this.accountNonExpired,
        required this.credentialsNonExpired,
    });

    factory OurUsers.fromJson(Map<String, dynamic> json) => OurUsers(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        password: json["password"],
        city: json["city"],
        role: json["role"],
        enabled: json["enabled"],
        username: json["username"],
        authorities: List<Authority>.from(json["authorities"].map((x) => Authority.fromJson(x))),
        accountNonLocked: json["accountNonLocked"],
        accountNonExpired: json["accountNonExpired"],
        credentialsNonExpired: json["credentialsNonExpired"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "password": password,
        "city": city,
        "role": role,
        "enabled": enabled,
        "username": username,
        "authorities": List<dynamic>.from(authorities.map((x) => x.toJson())),
        "accountNonLocked": accountNonLocked,
        "accountNonExpired": accountNonExpired,
        "credentialsNonExpired": credentialsNonExpired,
    };
}

class Authority {
    String authority;

    Authority({
        required this.authority,
    });

    factory Authority.fromJson(Map<String, dynamic> json) => Authority(
        authority: json["authority"],
    );

    Map<String, dynamic> toJson() => {
        "authority": authority,
    };
}
