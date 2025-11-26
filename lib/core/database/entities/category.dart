import 'package:objectbox/objectbox.dart';

@Entity()
class Category {
  @Id()
  int id = 0;

  String name; // Nombre de la categoría

  String iconName; // Nombre del icono (ej: 'home', 'subscriptions')

  int colorValue; // Color en formato int (ej: 0xFF2196F3)

  bool isDefault; // true para categorías predeterminadas

  bool isActive; // Para soft delete

  @Property(type: PropertyType.date)
  DateTime createdAt;

  Category({
    this.id = 0,
    required this.name,
    required this.iconName,
    required this.colorValue,
    this.isDefault = false,
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
