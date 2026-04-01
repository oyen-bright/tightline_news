FLUTTER := flutter

.PHONY: pub_get build_runner watch_runner clean_runner

pub_get:
	$(FLUTTER) pub get

build_runner:
	$(FLUTTER) pub run build_runner build --delete-conflicting-outputs

clean_runner:
	$(FLUTTER) pub run build_runner clean
