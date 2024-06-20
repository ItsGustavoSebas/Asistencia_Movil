import 'dart:convert';

List<Licencias> licenciasFromMap(String str) => List<Licencias>.from(json.decode(str).map((x) => Licencias.fromMap(x)));

String licenciasToMap(List<Licencias> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Licencias {
  int id;
  String nombre;
  DateTime fechaInicio;
  DateTime fechaFin;
  String motivo;
  bool? aprobado;

  Licencias({
    required this.id,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFin,
    required this.motivo,
    this.aprobado,
  });

  factory Licencias.fromMap(Map<String, dynamic> json) => Licencias(
    id: json["id"],
    nombre: json["nombre"],
    fechaInicio: DateTime.parse(json["fechaInicio"]),
    fechaFin: DateTime.parse(json["fechaFin"]),
    motivo: json["motivo"],
    aprobado: json["aprobado"] == null ? null : json["aprobado"] as bool?,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nombre": nombre,
    "fechaInicio": "${fechaInicio.year.toString().padLeft(4, '0')}-${fechaInicio.month.toString().padLeft(2, '0')}-${fechaInicio.day.toString().padLeft(2, '0')}",
    "fechaFin": "${fechaFin.year.toString().padLeft(4, '0')}-${fechaFin.month.toString().padLeft(2, '0')}-${fechaFin.day.toString().padLeft(2, '0')}",
    "motivo": motivo,
    "aprobado": aprobado,
  };
}
