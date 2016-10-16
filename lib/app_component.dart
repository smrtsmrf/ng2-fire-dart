// Copyright (c) 2016, Candice Humpherys. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'dart:html';
import 'firebase_service.dart';

@Component(
    selector: 'my-app',
    styleUrls: const ['app_component.css'],
    templateUrl: 'app_component.html',
    providers: const [FirebaseService]
)
class AppComponent implements OnInit, OnDestroy {
	// Initializing properties on the class
	final FirebaseService fbService;
	String name;
	String type;
	String choice;
	List<Favorite> favorites;

	// constructor. Initializes an instance of the service
	AppComponent(FirebaseService this.fbService);

	// method to add to the list via user input, then clear out the input fields
	void addFavourite() {
		print('from component');
		String n = name.trim();
		String t = type.trim();
		String c = choice.trim();
		fbService.addFavorite(name:n, type:t, choice:c);
		name = "";
		type = "";
		choice = "";
	}

	// sign in on page load and grab the favorites from the service. Use async/await so that favorites is defined
	void ngOnInit() async {
		print('signing in');
		await fbService.signIn();
		favorites = fbService.favorites;
	}

	// log out when the page is closed
	void ngOnDestroy() async {
		print('signing out');
		await fbService.signOut();
	}

}
