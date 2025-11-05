// lib/data/sound_catalog.dart
class SoundEntry {
  final String label;
  final String soundPath;
  const SoundEntry(this.label, this.soundPath);
}

class SoundCatalog {
  static List<SoundEntry> byCategory(String cat) {
    final map = <String, List<SoundEntry>>{
      'Instrumente': [
        SoundEntry('Trompete', 'assets/sfx/click.mp3'),
        SoundEntry('Gitarre', 'assets/sfx/click.mp3'),
        SoundEntry('Klavier', 'assets/sfx/click.mp3'),
        SoundEntry('Geige', 'assets/sfx/click.mp3'),
        SoundEntry('Flöte', 'assets/sfx/click.mp3'),
        SoundEntry('Saxofon', 'assets/sfx/click.mp3'),
        SoundEntry('Schlagzeug', 'assets/sfx/click.mp3'),
        SoundEntry('Akkordeon', 'assets/sfx/click.mp3'),
      ],
      'Tiere': [
        SoundEntry('Hund', 'assets/sfx/click.mp3'),
        SoundEntry('Katze', 'assets/sfx/click.mp3'),
        SoundEntry('Kuh', 'assets/sfx/click.mp3'),
        SoundEntry('Schaf', 'assets/sfx/click.mp3'),
        SoundEntry('Pferd', 'assets/sfx/click.mp3'),
        SoundEntry('Vogel', 'assets/sfx/click.mp3'),
        SoundEntry('Ente', 'assets/sfx/click.mp3'),
        SoundEntry('Löwe', 'assets/sfx/click.mp3'),
      ],
      'Fahrzeuge': [
        SoundEntry('Auto', 'assets/sfx/click.mp3'),
        SoundEntry('Motorrad', 'assets/sfx/click.mp3'),
        SoundEntry('Zug', 'assets/sfx/click.mp3'),
        SoundEntry('Flugzeug', 'assets/sfx/click.mp3'),
        SoundEntry('Schiff', 'assets/sfx/click.mp3'),
        SoundEntry('Traktor', 'assets/sfx/click.mp3'),
        SoundEntry('Feuerwehr', 'assets/sfx/click.mp3'),
        SoundEntry('Polizei', 'assets/sfx/click.mp3'),
      ],
      'Natur': [
        SoundEntry('Regen', 'assets/sfx/click.mp3'),
        SoundEntry('Gewitter', 'assets/sfx/click.mp3'),
        SoundEntry('Wind', 'assets/sfx/click.mp3'),
        SoundEntry('Wellen', 'assets/sfx/click.mp3'),
        SoundEntry('Vögel', 'assets/sfx/click.mp3'),
        SoundEntry('Wald', 'assets/sfx/click.mp3'),
        SoundEntry('Bach', 'assets/sfx/click.mp3'),
        SoundEntry('Lagerfeuer', 'assets/sfx/click.mp3'),
      ],
      'Küche': [
        SoundEntry('Pfanne', 'assets/sfx/click.mp3'),
        SoundEntry('Wasserkocher', 'assets/sfx/click.mp3'),
        SoundEntry('Mixer', 'assets/sfx/click.mp3'),
        SoundEntry('Ofen', 'assets/sfx/click.mp3'),
        SoundEntry('Teller', 'assets/sfx/click.mp3'),
        SoundEntry('Besteck', 'assets/sfx/click.mp3'),
        SoundEntry('Mikrowelle', 'assets/sfx/click.mp3'),
        SoundEntry('Toaster', 'assets/sfx/click.mp3'),
      ],
      'Stadt': [
        SoundEntry('Straßenbahn', 'assets/sfx/click.mp3'),
        SoundEntry('Baustelle', 'assets/sfx/click.mp3'),
        SoundEntry('Menschen', 'assets/sfx/click.mp3'),
        SoundEntry('Markt', 'assets/sfx/click.mp3'),
        SoundEntry('Brunnen', 'assets/sfx/click.mp3'),
        SoundEntry('Sirene', 'assets/sfx/click.mp3'),
        SoundEntry('Türklingel', 'assets/sfx/click.mp3'),
        SoundEntry('U-Bahn', 'assets/sfx/click.mp3'),
      ],
      'Emotionen': [
        SoundEntry('Lachen', 'assets/sfx/click.mp3'),
        SoundEntry('Weinen', 'assets/sfx/click.mp3'),
        SoundEntry('Staunen', 'assets/sfx/click.mp3'),
        SoundEntry('Ärger', 'assets/sfx/click.mp3'),
        SoundEntry('Erschrecken', 'assets/sfx/click.mp3'),
        SoundEntry('Gähnen', 'assets/sfx/click.mp3'),
        SoundEntry('Jubel', 'assets/sfx/click.mp3'),
        SoundEntry('Applaus', 'assets/sfx/click.mp3'),
      ],
      'Retro': [
        SoundEntry('8-Bit 1', 'assets/sfx/click.mp3'),
        SoundEntry('8-Bit 2', 'assets/sfx/click.mp3'),
        SoundEntry('8-Bit 3', 'assets/sfx/click.mp3'),
        SoundEntry('8-Bit 4', 'assets/sfx/click.mp3'),
        SoundEntry('8-Bit 5', 'assets/sfx/click.mp3'),
        SoundEntry('8-Bit 6', 'assets/sfx/click.mp3'),
        SoundEntry('8-Bit 7', 'assets/sfx/click.mp3'),
        SoundEntry('8-Bit 8', 'assets/sfx/click.mp3'),
      ],
      'Glocken': [
        SoundEntry('Kleine Glocke', 'assets/sfx/click.mp3'),
        SoundEntry('Große Glocke', 'assets/sfx/click.mp3'),
        SoundEntry('Dreiklang', 'assets/sfx/click.mp3'),
        SoundEntry('Kirche', 'assets/sfx/click.mp3'),
        SoundEntry('Bike Bell', 'assets/sfx/click.mp3'),
        SoundEntry('Türglocke', 'assets/sfx/click.mp3'),
        SoundEntry('Windspiel', 'assets/sfx/click.mp3'),
        SoundEntry('Metallisch', 'assets/sfx/click.mp3'),
      ],
    };

    return map[cat] ?? map['Instrumente']!;
  }
}
