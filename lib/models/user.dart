
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
    List<Role> roles;
    Cargo cargo;
    bool enabled;
    bool credentialsNonExpired;
    bool accountNonExpired;
    bool accountNonLocked;
    String username;
    List<Authority> authorities;

    OurUsers({
        required this.id,
        required this.email,
        required this.name,
        required this.password,
        required this.roles,
        required this.cargo,
        required this.enabled,
        required this.credentialsNonExpired,
        required this.accountNonExpired,
        required this.accountNonLocked,
        required this.username,
        required this.authorities,
    });

    factory OurUsers.fromJson(Map<String, dynamic> json) => OurUsers(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        password: json["password"],
        roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
        cargo: Cargo.fromJson(json["cargo"]),
        enabled: json["enabled"],
        credentialsNonExpired: json["credentialsNonExpired"],
        accountNonExpired: json["accountNonExpired"],
        accountNonLocked: json["accountNonLocked"],
        username: json["username"],
        authorities: List<Authority>.from(json["authorities"].map((x) => Authority.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "password": password,
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
        "cargo": cargo.toJson(),
        "enabled": enabled,
        "credentialsNonExpired": credentialsNonExpired,
        "accountNonExpired": accountNonExpired,
        "accountNonLocked": accountNonLocked,
        "username": username,
        "authorities": List<dynamic>.from(authorities.map((x) => x.toJson())),
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

class Cargo {
    int id;
    String name;

    Cargo({
        required this.id,
        required this.name,
    });

    factory Cargo.fromJson(Map<String, dynamic> json) => Cargo(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

class Role {
    int id;
    String name;
    List<Cargo> permissions;

    Role({
        required this.id,
        required this.name,
        required this.permissions,
    });

    factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        permissions: List<Cargo>.from(json["permissions"].map((x) => Cargo.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "permissions": List<dynamic>.from(permissions.map((x) => x.toJson())),
    };
}
