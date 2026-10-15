class Supplier {
  final String id;
  final String name;

  Supplier({
    required this.id,
    required this.name,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    // We assume the API returns 'id' or 'frs' for the identifier and 'name' for the supplier name
    return Supplier(
      id: json['id']?.toString() ?? json['frs']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Fournisseur inconnu',
    );
  }
}
