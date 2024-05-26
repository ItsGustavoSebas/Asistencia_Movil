
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    int id;
    String name;
    String email;
    dynamic emailVerifiedAt;
    int ci;
    int telefono;
    String direccion;
    dynamic twoFactorConfirmedAt;
    dynamic currentTeamId;
    int postulante;
    int empleado;
    String createdAt;
    String updatedAt;
    String profilePhotoUrl;
    String? foto;

    User({
        required this.id,
        required this.name,
        required this.email,
        required this.emailVerifiedAt,
        required this.ci,
        required this.telefono,
        required this.direccion,
        required this.twoFactorConfirmedAt,
        required this.currentTeamId,
        required this.postulante,
        required this.empleado,
        required this.createdAt,
        required this.updatedAt,
        required this.profilePhotoUrl,
        required this.foto
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        ci: json["ci"],
        telefono: json["telefono"],
        direccion: json["direccion"],
        twoFactorConfirmedAt: json["two_factor_confirmed_at"],
        currentTeamId: json["current_team_id"],
        postulante: json["Postulante"],
        empleado: json["Empleado"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        profilePhotoUrl: json["profile_photo_url"],
        foto: json["foto"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "ci": ci,
        "telefono": telefono,
        "direccion": direccion,
        "two_factor_confirmed_at": twoFactorConfirmedAt,
        "current_team_id": currentTeamId,
        "Postulante": postulante,
        "Empleado": empleado,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "profile_photo_url": profilePhotoUrl,
        "foto": foto,
    };
}
