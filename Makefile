FLUTTER := flutter

.PHONY: pub_get build_runner clean_runner test test_coverage

pub_get:
	$(FLUTTER) pub get

build_runner:
	$(FLUTTER) pub run build_runner build --delete-conflicting-outputs

clean_runner:
	$(FLUTTER) pub run build_runner clean

test:
	$(FLUTTER) test

test_coverage:
	$(FLUTTER) test --coverage
