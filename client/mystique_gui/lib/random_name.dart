import 'dart:math';
// import 'dart:t';

var animal_names = [
  "Lion",
  "Tiger",
  "Elephant",
  "Giraffe",
  "Zebra",
  "Cheetah",
  "Rhino",
  "Hippo",
  "Kangaroo",
  "Gorilla",
  "Bear",
  "Bear",
  "Panda",
  "Wolf",
  "Fox",
  "Hyena",
  "Leopard",
  "Jaguar",
  "Crocodile",
  "Alligator",
  "Eagle",
  "Falcon",
  "Leopard",
  "Chimpanzee",
  "Koala",
  "Python",
  "Anaconda",
  "Bison",
  "Gazelle",
  "Octopus",
  "Dolphin",
  "Orca",
  "Dragon",
  "Lemur",
  "Meerkat",
  "Ostrich",
  "Platypus",
  "Panda",
  "Turtle",
  "Sloth",
  "Devil",
  "Vulture",
  "Walrus",
  "Boar",
  "Wolverine",
  "Yak",
  "Raccoon",
  "Puma",
  "Ibex",
  "Whale"
];

var adjectives = [
  "Happy",
  "Joyful",
  "Peaceful",
  "Loving",
  "Kind",
  "Generous",
  "Grateful",
  "Hopeful",
  "Playful",
  "Cheerful",
  "Friendly",
  "Honest",
  "Optimistic",
  "Energetic",
  "Creative",
  "Enthusiastic",
  "Radiant",
  "Confident",
  "Compassionate",
  "Sincere"
];

String genRandName() {
  var res = "";
  var random = Random(DateTime.now().microsecondsSinceEpoch);
  var animal_num = random.nextInt(animal_names.length);
  var adj_num = random.nextInt(adjectives.length);
  // var rand_num = random.nextInt(20);
  res += "${adjectives[adj_num]} ${animal_names[animal_num]} ";
  return res;
}


