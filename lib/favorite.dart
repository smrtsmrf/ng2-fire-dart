// define a class for the favorites with 3 properties
class Favorite {
	final String name;
	final String type;
	final String choice;

	// constructor specifying that the 3 inputs will be assigned to the name, type, and choice properties
	Favorite(this.name, this.type, this.choice);

	// I'm not super solid on this fromMap and toMap. It's something to do with Firebase only being able to handle certain kinds of data, and so we have to convert from the Favorite class to a Firebase appropriate form and vice versa. That's the extent of my knowledge of what's going on here
	Favorite.fromMap(Map map) : this(map['name'], map['type'], map['choice']);

	Map toMap() => {
		"name": name,
		"type": type,
		"choice": choice
	};
}