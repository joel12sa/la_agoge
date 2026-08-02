import 'gender.dart';

enum Archetype {
  depredador,
  arquitecta;

  static Archetype? fromString(String? value) {
    for (final archetype in Archetype.values) {
      if (archetype.name == value) return archetype;
    }
    return null;
  }
}

class ArchetypeOption {
  const ArchetypeOption({
    required this.gender,
    required this.value,
    required this.label,
    required this.prompt,
  });

  final Gender gender;
  final Archetype value;
  final String label;
  final String prompt;

  static const maleOptions = [
    ArchetypeOption(
      gender: Gender.male,
      value: Archetype.depredador,
      label: 'DEPREDADOR',
      prompt: '¿Eres presa o depredador?',
    ),
  ];

  static const femaleOptions = [
    ArchetypeOption(
      gender: Gender.female,
      value: Archetype.arquitecta,
      label: 'ARQ. DE UN IMPERIO',
      prompt: '¿Eres una muñeca rota o arquitecta de tu destino?',
    ),
  ];

  static List<ArchetypeOption> optionsFor(Gender gender) => switch (gender) {
        Gender.male => maleOptions,
        Gender.female => femaleOptions,
      };
}