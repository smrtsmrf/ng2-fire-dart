import 'dart:async';

import 'package:angular2/core.dart';
import 'package:firebase3/firebase.dart' as fb;

import 'favorite.dart';

@Injectable()
class FirebaseService {
	// Initialize some private variables and one public one
	fb.Auth _fbAuth;
	fb.User user;
	fb.Database _fbDatabase;
	fb.DatabaseReference _fbRefFavorites;

	List<Favorite> favorites;

	// constructor function. Set up the app and assign some invoked functions onto the private variables initialized above
	FirebaseService() {
		fb.initializeApp(
			apiKey: "AIzaSyACu96-JJ5UE1G359VebCxBIAdzi7qPmP0",
			authDomain: "smrtsmrf-ng-fire-challenge.firebaseapp.com",
			databaseURL: "https://smrtsmrf-ng-fire-challenge.firebaseio.com",
			storageBucket: "smrtsmrf-ng-fire-challenge.appspot.com"
		);

		_fbDatabase = fb.database();
		_fbRefFavorites = _fbDatabase.ref('favorites');
		_fbAuth = fb.auth();
		// listen for a change in auth and when it happens, call the _authChanged method
		_fbAuth.onAuthStateChanged.listen(_authChanged);
		
	}

	// sign in as an anonymous user. Future is like a promise in JS. Use async/await instead of .then
	Future signIn() async {
		try {
			await _fbAuth.signInAnonymously();
		} catch (e) {
			throw _handleError(e);
		}
	}

	// sign out
	void signOut() {
		_fbAuth.signOut();
	}

	// invoked when auth changed. When a user is logged in (which is supposed to happen on page load for this simple app), listen for when a new one is added and then call _updateFavorites. I'm a little shaky on the implementation of this. I get the idea of it though. For some reason, this is being run when the app loads up, even though I'm not logging in.
	void _authChanged(fb.AuthEvent event) {
		print('running this function');
		user = event.user;
		if (user != null) {
			favorites = [];
			_fbRefFavorites.onChildAdded.listen(_updateFavorites);
		}
	}

	// Invoked when a favorite is added (via html or firebase console). I'm a little shaky on this one too. But I know it's grabbing the new message and converting it to a type Favorite and adding it to the list.
	void _updateFavorites(fb.QueryEvent event) {
		Favorite fav = new Favorite.fromMap(event.snapshot.val());
		favorites.add(fav);
	}	

	// Add a new entry from the user input in html
	Future addFavorite({String name, String type, String choice}) async {
		print('adding a new one');
		try {
			Favorite fav = new Favorite(name, type, choice);
			await _fbRefFavorites.push(fav.toMap());
		} catch(e) {
			throw _handleError(e);
		}
	}

	// handle the error
	Exception _handleError(dynamic e) {
		print(e);
		return new Exception('Server error; cause: $e');
	}

}