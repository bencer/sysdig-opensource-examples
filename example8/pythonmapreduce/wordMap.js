function wordMap() {

	var words = this.text.match(/\w+/g);

	if (words == null) {
		return;
	}

	for (var i = 0; i < words.length; i++) {
		emit(words[i], {count: 1});
	}
}
