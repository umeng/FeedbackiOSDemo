test:
	xctool -project FeedbackDemo.xcodeproj -scheme FeedbackDemo -configuration Debug -sdk "iphonesimulator8.0" build

release:
	git archive master --prefix='UMFeedback_iOS_1.4.2/' --format=zip > UMFeedback_iOS_1.4.2.zip
	mv UMFeedback_iOS_1.4.2.zip ~/Downloads
