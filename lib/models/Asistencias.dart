import 'dart:convert';

List<Asistencias> asistenciasFromMap(String str) =>
    List<Asistencias>.from(json.decode(str).map((x) => Asistencias.fromMap(x)));

String asistenciasToMap(List<Asistencias> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Asistencias {
  int id;
  DateTime fecha;
  double latitud;
  double longitud;
  String estado;
  ProgramacionAcademica programacionAcademica;

  Asistencias({
    required this.id,
    required this.fecha,
    required this.latitud,
    required this.longitud,
    required this.estado,
    required this.programacionAcademica,
  });

  factory Asistencias.fromMap(Map<String, dynamic> json) => Asistencias(
        id: json["id"],
        fecha: DateTime.parse(json["fecha"]),
        latitud: json["latitud"].toDouble(),
        longitud: json["longitud"].toDouble(),
        estado: json["estado"],
        programacionAcademica:
            ProgramacionAcademica.fromMap(json["programacionAcademica"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "fecha":
            "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "latitud": latitud,
        "longitud": longitud,
        "estado": estado,
        "programacionAcademica": programacionAcademica.toMap(),
      };
}

class ProgramacionAcademica {
  int id;
  int aula;
  Modulo modulo;
  Grupo grupo;
  DiaHorario diaHorario;

  ProgramacionAcademica({
    required this.id,
    required this.aula,
    required this.modulo,
    required this.grupo,
    required this.diaHorario,
  });

  factory ProgramacionAcademica.fromMap(Map<String, dynamic> json) =>
      ProgramacionAcademica(
        id: json["id"],
        aula: json["aula"],
        modulo: Modulo.fromMap(json["modulo"]),
        grupo: Grupo.fromMap(json["grupo"]),
        diaHorario: DiaHorario.fromMap(json["diaHorario"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "aula": aula,
        "modulo": modulo.toMap(),
        "grupo": grupo.toMap(),
        "diaHorario": diaHorario.toMap(),
      };
}

class DiaHorario {
  int id;
  Dia dia;
  Horario horario;

  DiaHorario({
    required this.id,
    required this.dia,
    required this.horario,
  });

  factory DiaHorario.fromMap(Map<String, dynamic> json) => DiaHorario(
        id: json["id"],
        dia: Dia.fromMap(json["dia"]),
        horario: Horario.fromMap(json["horario"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "dia": dia.toMap(),
        "horario": horario.toMap(),
      };
}

class Dia {
  int id;
  String name;

  Dia({
    required this.id,
    required this.name,
  });

  factory Dia.fromMap(Map<String, dynamic> json) => Dia(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}

class Horario {
  int id;
  String horaInicio;
  String horaFin;

  Horario({
    required this.id,
    required this.horaInicio,
    required this.horaFin,
  });

  factory Horario.fromMap(Map<String, dynamic> json) => Horario(
        id: json["id"],
        horaInicio: json["horaInicio"],
        horaFin: json["horaFin"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "horaInicio": horaInicio,
        "horaFin": horaFin,
      };
}

class Grupo {
  int id;
  String name;
  MateriaCarrera materiaCarrera;
  Docente docente;
  FacultadGestion facultadGestion;

  Grupo({
    required this.id,
    required this.name,
    required this.materiaCarrera,
    required this.docente,
    required this.facultadGestion,
  });

  factory Grupo.fromMap(Map<String, dynamic> json) => Grupo(
        id: json["id"],
        name: json["name"],
        materiaCarrera: MateriaCarrera.fromMap(json["materiaCarrera"]),
        docente: Docente.fromMap(json["docente"]),
        facultadGestion: FacultadGestion.fromMap(json["facultadGestion"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "materiaCarrera": materiaCarrera.toMap(),
        "docente": docente.toMap(),
        "facultadGestion": facultadGestion.toMap(),
      };
}

class Docente {
  int id;
  String email;
  String name;
  String password;
  List<Role> roles;
  Dia cargo;
  bool enabled;
  List<Authority> authorities;
  String username;
  bool accountNonExpired;
  bool credentialsNonExpired;
  bool accountNonLocked;

  Docente({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.roles,
    required this.cargo,
    required this.enabled,
    required this.authorities,
    required this.username,
    required this.accountNonExpired,
    required this.credentialsNonExpired,
    required this.accountNonLocked,
  });

  factory Docente.fromMap(Map<String, dynamic> json) => Docente(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        password: json["password"],
        roles: List<Role>.from(json["roles"].map((x) => Role.fromMap(x))),
        cargo: Dia.fromMap(json["cargo"]),
        enabled: json["enabled"],
        authorities: List<Authority>.from(
            json["authorities"].map((x) => Authority.fromMap(x))),
        username: json["username"],
        accountNonExpired: json["accountNonExpired"],
        credentialsNonExpired: json["credentialsNonExpired"],
        accountNonLocked: json["accountNonLocked"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "name": name,
        "password": password,
        "roles": List<dynamic>.from(roles.map((x) => x.toMap())),
        "cargo": cargo.toMap(),
        "enabled": enabled,
        "authorities": List<dynamic>.from(authorities.map((x) => x.toMap())),
        "username": username,
        "accountNonExpired": accountNonExpired,
        "credentialsNonExpired": credentialsNonExpired,
        "accountNonLocked": accountNonLocked,
      };
}

class Authority {
  String authority;

  Authority({
    required this.authority,
  });

  factory Authority.fromMap(Map<String, dynamic> json) => Authority(
        authority: json["authority"],
      );

  Map<String, dynamic> toMap() => {
        "authority": authority,
      };
}

class Role {
  int id;
  String name;
  List<Dia> permissions;

  Role({
    required this.id,
    required this.name,
    required this.permissions,
  });

  factory Role.fromMap(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        permissions:
            List<Dia>.from(json["permissions"].map((x) => Dia.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "permissions": List<dynamic>.from(permissions.map((x) => x.toMap())),
      };
}

class FacultadGestion {
  int id;
  Dia gestion;
  Dia facultad;
  List<FechaImportante> fechaImportantes;

  FacultadGestion({
    required this.id,
    required this.gestion,
    required this.facultad,
    required this.fechaImportantes,
  });

  factory FacultadGestion.fromMap(Map<String, dynamic> json) => FacultadGestion(
        id: json["id"],
        gestion: Dia.fromMap(json["gestion"]),
        facultad: Dia.fromMap(json["facultad"]),
        fechaImportantes: List<FechaImportante>.from(
            json["fechaImportantes"].map((x) => FechaImportante.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "gestion": gestion.toMap(),
        "facultad": facultad.toMap(),
        "fechaImportantes":
            List<dynamic>.from(fechaImportantes.map((x) => x.toMap())),
      };
}

class FechaImportante {
  int id;
  String descripcion;
  DateTime fechaInicio;
  DateTime fechaFin;
  Dia tipo;

  FechaImportante({
    required this.id,
    required this.descripcion,
    required this.fechaInicio,
    required this.fechaFin,
    required this.tipo,
  });

  factory FechaImportante.fromMap(Map<String, dynamic> json) => FechaImportante(
        id: json["id"],
        descripcion: json["descripcion"],
        fechaInicio: DateTime.parse(json["fechaInicio"]),
        fechaFin: DateTime.parse(json["fechaFin"]),
        tipo: Dia.fromMap(json["tipo"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "descripcion": descripcion,
        "fechaInicio":
            "${fechaInicio.year.toString().padLeft(4, '0')}-${fechaInicio.month.toString().padLeft(2, '0')}-${fechaInicio.day.toString().padLeft(2, '0')}",
        "fechaFin":
            "${fechaFin.year.toString().padLeft(4, '0')}-${fechaFin.month.toString().padLeft(2, '0')}-${fechaFin.day.toString().padLeft(2, '0')}",
        "tipo": tipo.toMap(),
      };
}

class MateriaCarrera {
  int id;
  int semestre;
  Materia materia;
  Carrera carrera;

  MateriaCarrera({
    required this.id,
    required this.semestre,
    required this.materia,
    required this.carrera,
  });

  factory MateriaCarrera.fromMap(Map<String, dynamic> json) => MateriaCarrera(
        id: json["id"],
        semestre: json["semestre"],
        materia: Materia.fromMap(json["materia"]),
        carrera: Carrera.fromMap(json["carrera"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "semestre": semestre,
        "materia": materia.toMap(),
        "carrera": carrera.toMap(),
      };
}

class Carrera {
  int id;
  String name;
  Dia facultad;

  Carrera({
    required this.id,
    required this.name,
    required this.facultad,
  });

  factory Carrera.fromMap(Map<String, dynamic> json) => Carrera(
        id: json["id"],
        name: json["name"],
        facultad: Dia.fromMap(json["facultad"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "facultad": facultad.toMap(),
      };
}

class Materia {
  int id;
  String sigla;
  String name;

  Materia({
    required this.id,
    required this.sigla,
    required this.name,
  });

  factory Materia.fromMap(Map<String, dynamic> json) => Materia(
        id: json["id"],
        sigla: json["sigla"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "sigla": sigla,
        "name": name,
      };
}

class Modulo {
  int id;
  String name;
  double latitud;
  double longitud;
  Dia facultad;

  Modulo({
    required this.id,
    required this.name,
    required this.latitud,
    required this.longitud,
    required this.facultad,
  });

  factory Modulo.fromMap(Map<String, dynamic> json) => Modulo(
        id: json["id"],
        name: json["name"],
        latitud: json["latitud"].toDouble(),
        longitud: json["longitud"].toDouble(),
        facultad: Dia.fromMap(json["facultad"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "latitud": latitud,
        "longitud": longitud,
        "facultad": facultad.toMap(),
      };
}
